module Web.Component (runWebApp) where

import qualified BlogPost.Component       as BlogPost

import           Web.Internal.View.Pages
import           Web.Internal.View.Static

import           Control.Monad.IO.Class   (liftIO)
import           Data.Maybe               (fromMaybe)
import           System.Environment       (lookupEnv)
import           Web.Scotty

runWebApp :: BlogPost.Component -> IO ()
runWebApp bpComponent = do
  port <- fromMaybe "3000" <$> lookupEnv "PORT"
  scotty (read port) $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css; charset=utf-8"
      text renderCss

    get "/" $ redirect "/blog"
    get "/blog" $ liftIO (renderHomePage bpComponent) >>= html

    get "/about" $ liftIO renderAboutPage >>= html
