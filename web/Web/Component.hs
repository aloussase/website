{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE UndecidableInstances #-}
module Web.Component (run) where

import qualified BlogPost.Component              as BlogPost

import           Web.Internal.View.HtmlPresenter
import           Web.Internal.View.Navbar

import           Control.Monad.IO.Class          (liftIO)
import           Data.Maybe                      (fromMaybe)
import           Data.Proxy                      (Proxy (..))
import           System.Environment              (lookupEnv)
import           Text.Blaze.Html                 (toMarkup)
import           Text.Blaze.Html.Renderer.Text
import           Text.Cassius
import           Text.Hamlet
import           Web.Scotty


run :: (BlogPost.Repository r, Parsable (BlogPost.Id r)) => r -> IO ()
run r = do
  port <- fromMaybe "3000" <$> lookupEnv "PORT"
  scotty (read port) $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css; charset=utf-8"
      text $ renderCss $ $(cassiusFile "static/templates/Styles.cassius") render

    get "/" $ redirect "/blog"
    get "/blog" $ do
      let getAllPostsUseCase = BlogPost.newGetAllPosts r (Proxy @HtmlPresenter)
      posts <- liftIO (toMarkup <$> BlogPost.getAllPosts getAllPostsUseCase)
      html $ renderHtml $(shamletFile "static/templates/Home.hamlet")

    get "/blog/:id" $ do
      postId <- param "id"
      blogPost <- liftIO $ toMarkup <$> BlogPost.getSinglePost postId r (Proxy @HtmlPresenter)
      html $ renderHtml $(shamletFile "static/templates/BlogPost.hamlet")

    get "/about" $ html $ renderHtml $(shamletFile "static/templates/About.hamlet")

  where
    render = undefined
