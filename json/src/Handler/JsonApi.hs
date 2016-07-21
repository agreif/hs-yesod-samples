module Handler.JsonApi where

import Import

-- helpers

newtype CommentAttrs = CommentAttrs Text

instance FromJSON CommentAttrs where
    parseJSON (Object o) = CommentAttrs <$> o .: "content"
    parseJSON _          = mzero

toComment :: PostId -> CommentAttrs -> Comment
toComment pid (CommentAttrs content) = Comment
    { commentPost    = pid
    , commentContent = content
    }

-- posts

getPostsR :: Handler Value
getPostsR = do
    posts <- runDB $ selectList [] [] :: Handler [Entity Post]

    return $ object ["posts" .= posts]

postPostsR :: Handler ()
postPostsR = do
    post <- requireJsonBody :: Handler Post
    _    <- runDB $ insert post

    sendResponseStatus status201 ("CREATED" :: Text)

-- post

getPostR :: PostId -> Handler Value
getPostR pid = do
    post <- runDB $ get404 pid

    return $ object ["post" .= (Entity pid post)]

putPostR :: PostId -> Handler Value
putPostR pid = do
    post <- requireJsonBody :: Handler Post

    runDB $ replace pid post

    sendResponseStatus status200 ("UPDATED" :: Text)

deletePostR :: PostId -> Handler Value
deletePostR pid = do
    runDB $ delete pid

    sendResponseStatus status200 ("DELETED" :: Text)

-- comments

getCommentsR :: PostId -> Handler Value
getCommentsR pid = do
    comments <- runDB $ selectList [CommentPost ==. pid] []

    return $ object ["comments" .= comments]

postCommentsR :: PostId -> Handler ()
postCommentsR pid = do
    _ <- runDB . insert . toComment pid =<< requireJsonBody

    sendResponseStatus status201 ("CREATED" :: Text)

-- comment

getCommentR :: PostId -> CommentId -> Handler Value
getCommentR _ cid = do
    comment <- runDB $ get404 cid

    return $ object ["comment" .= (Entity cid comment)]

deleteCommentR :: PostId -> CommentId -> Handler ()
deleteCommentR _ cid = do
    runDB $ delete cid

    sendResponseStatus status200 ("DELETED" :: Text)

putCommentR :: PostId -> CommentId -> Handler ()
putCommentR pid cid = do
    runDB . replace cid . toComment pid =<< requireJsonBody

    sendResponseStatus status200 ("UPDATED" :: Text)
