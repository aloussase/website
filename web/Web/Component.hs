module Web.Component (runWebApp) where

import qualified BlogPost.Component       as BlogPost

import           Web.Internal.View.Pages
import           Web.Internal.View.Static

import           Control.Monad.IO.Class   (liftIO)
import           Web.Scotty

runWebApp :: BlogPost.Component -> IO ()
runWebApp bpComponent = scotty 3000 $ do
  get "/styles.css" $ do
    setHeader "Content-Type" "text/css; charset=utf-8"
    text renderCss

  get "/" $ redirect "/blog"
  get "/blog" $ liftIO (renderHomePage bpComponent) >>= html

  get "/about" $ liftIO renderAboutPage >>= html
