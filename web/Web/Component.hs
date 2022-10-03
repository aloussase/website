module Web.Component (runWebApp) where

import qualified BlogPost.Component     as BlogPost
import qualified View.Component         as View

import           Control.Monad.IO.Class (liftIO)
import           Web.Scotty

runWebApp :: (BlogPost.Service blogPostService, BlogPost.Repository blogPostRepository)
  => blogPostService
  -> blogPostRepository
  -> IO ()
runWebApp bpService bpRepository = scotty 3000 $ do
  get "/styles.css" $ do
    setHeader "Content-Type" "text/css; charset=utf-8"
    text View.renderCss

  get "/" $ do
    homePage <- liftIO $ View.renderHomePage bpService bpRepository
    html homePage
