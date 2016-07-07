# HashDB-Auth sample

features:
- stores userId with hashed password in DB
- marked admin routes

changes in `Foundation.hs`:

    import Yesod.Auth.HashDB

    instance Yesod App where
        ...
        isAuthorized route _
            | "admin" `member` routeAttrs route = do
              maybeUser <- maybeAuthId
              case maybeUser of
                  Nothing -> return AuthenticationRequired
                  Just _ -> return Authorized
            | otherwise =return Authorized


    instance YesodPersist App where
        ...
        authenticate creds = runDB $ do
            x <- getBy $ UniqueUser $ credsIdent creds
            case x of
                Just (Entity uid _) -> return $ Authenticated uid
                Nothing -> return $ ServerError "error"
        ...
	authPlugins _ = [authHashDB (Just . UniqueUser)]

    instance HashDBUser User where
        userPasswordHash = userPassword
        setPasswordHash h u = u { userPassword = Just h }

changes in `config/routes`:

    / HomeR GET POST
    /admin/admin1 Admin1R GET !admin
    /admin/admin2 Admin2R GET !admin

changes in `Handler/Admin.hs`

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


create password hash:

    $ stack exec -- ghci -XOverloadedStrings
    GHCi, version 7.10.3: http://www.haskell.org/ghc/  :? for help
    Prelude> import Crypto.PasswordStore
    Crypto.PasswordStore> makePassword "foobar" 17
    "sha256|17|OIQ45UxulhjTIcFoCUTNJw==|cfHUNiyscBZ6bHxGg3h5RjzCG9ohABFgQRUtQOizmxk="

insert into db:

    $ sqlite3 hashdb-auth.sqlite3
    SQLite version 3.12.2 2016-04-18 17:30:31
    Enter ".help" for usage hints.
    sqlite> insert into user values (1,'admin', 'sha256|17|OIQ45UxulhjTIcFoCUTNJw==|cfHUNiyscBZ6bHxGg3h5RjzCG9ohABFgQRUtQOizmxk=');


![pic1](pics/pic1.png)
