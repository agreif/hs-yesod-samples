module Handler.Admin where
import Import

getAdmin1R :: Handler Html
getAdmin1R = do
    defaultLayout
        [whamlet|
            <p>Admin 1
            <p>
                <a href=@{AuthR LogoutR}>Logout
        |]

getAdmin2R :: Handler Html
getAdmin2R = do
    defaultLayout
        [whamlet|
            <p>Admin 2
            <p>
                <a href=@{AuthR LogoutR}>Logout
        |]
