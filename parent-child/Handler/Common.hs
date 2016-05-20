-- | Common handler functions.
module Handler.Common where

import Data.FileEmbed (embedFile)
import Import

import Text.Blaze.Html (preEscapedToHtml)

getFaviconR :: Handler TypedContent
getFaviconR = do cacheSeconds $ 60 * 60 * 24 * 30 -- cache for a month
                 return $ TypedContent "image/x-icon"
                        $ toContent $(embedFile "config/favicon.ico")

getRobotsR :: Handler TypedContent
getRobotsR = return $ TypedContent typePlain
                    $ toContent $(embedFile "config/robots.txt")

renderFailureHtml :: [Text] -> Html
renderFailureHtml texts =
  toHtml [preEscapedToHtml ("<div class=\"alert alert-danger\">" :: Text),
          intercalate (preEscapedToHtml ("<br>" :: Text)) $ map toHtml texts,
          preEscapedToHtml ("</div>" :: Text)]

renderInfoHtml :: [Text] -> Html
renderInfoHtml texts =
  toHtml [preEscapedToHtml ("<div class=\"alert alert-info\">" :: Text),
          intercalate (preEscapedToHtml ("<br>" :: Text)) $ map toHtml texts,
          preEscapedToHtml ("</div>" :: Text)]
