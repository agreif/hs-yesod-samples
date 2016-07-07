module Handler.Person where

import Import
import Yesod.Form.Bootstrap3
import Handler.Common

getPersonListR :: Handler Html
getPersonListR = do
  people <- runDB $ selectList [] [Asc PersonName]
  defaultLayout $ do
        $(widgetFile "personList")

getPersonDetailR :: PersonId -> Handler Html
getPersonDetailR personId = do
  person <- runDB $ get404 personId
  defaultLayout $ do
        $(widgetFile "personDetail")

getPersonAddR :: Handler Html
getPersonAddR = do
  (formWidget, formEnctype) <- generateFormPost personAForm
  defaultLayout $ do
    $(widgetFile "personAdd")

personAForm :: Form Person
personAForm =  renderBootstrap3 (BootstrapHorizontalForm (ColSm 0) (ColSm 2) (ColSm 0) (ColSm 8)) $ Person
    <$> areq textField (bfs ("Name" :: Text)) Nothing
    <*> areq intField (bfs ("Age" :: Text)) Nothing
    <*  bootstrapSubmit (BootstrapSubmit ("Add person" :: Text) "btn btn-primary" [])

postPersonAddR :: Handler Html
postPersonAddR = do
  ((result, formWidget), formEnctype) <- runFormPost personAForm
  case result of
       FormSuccess person -> do
         personId <- runDB $ insert person
         setMessage $ renderInfoHtml ["Person added."]
         redirect $ PersonDetailR personId
       FormMissing -> do
         setMessage $ renderFailureHtml ["No data provided."]
         defaultLayout $ do
           $(widgetFile "personAdd")
       FormFailure texts -> do
         setMessage $ renderFailureHtml texts
         defaultLayout $ do
           $(widgetFile "personAdd")

