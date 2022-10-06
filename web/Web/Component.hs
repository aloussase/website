module Web.Component (runWebApp) where

import qualified BlogPost.Component     as BlogPost
import qualified View.Component         as View

import           Control.Monad.IO.Class (liftIO)
import           Web.Scotty

runWebApp :: BlogPost.Component -> IO ()
runWebApp bpComponent = scotty 3000 $ do
  get "/styles.css" $ do
    setHeader "Content-Type" "text/css; charset=utf-8"
    text View.renderCss

  get "/" $ redirect "/blog"
  get "/blog" $ do
    homePage <- liftIO $ View.renderHomePage bpComponent
    html homePage

  get "/about" $ liftIO View.renderAboutPage >>= html
