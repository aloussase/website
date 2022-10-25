{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE UndecidableInstances #-}
module Web.Component (run) where

import qualified BlogPost.Component              as BlogPost

import           Web.Internal.View.HtmlPresenter

import           Control.Monad.IO.Class          (liftIO)
import           Data.Maybe                      (fromMaybe)
import           Data.Proxy                      (Proxy (..))
import           System.Environment              (lookupEnv)
import           Text.Blaze.Html                 (ToMarkup, toMarkup)
import           Text.Blaze.Html.Renderer.Text
import           Text.Cassius
import           Text.Hamlet
import           Web.Scotty

header :: String -> Html
header pageTitle = $(shamletFile "static/templates/Header.hamlet")

footer :: Html
footer = $(shamletFile "static/templates/Footer.hamlet")

navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")

getAllPosts :: (BlogPost.PersistenceAdapter r, BlogPost.PresenterAdapter p, ToMarkup (BlogPost.Output p))
  => r
  -> p
  -> ActionM ()
getAllPosts r p = do
  let getAllPostsUseCase = BlogPost.newGetAllPosts r p
  posts <- liftIO (toMarkup <$> BlogPost.getAllPosts getAllPostsUseCase)
  html $ renderHtml $(shamletFile "static/templates/Home.hamlet")

getSinglePost :: (BlogPost.PersistenceAdapter r, BlogPost.PresenterAdapter p, ToMarkup (BlogPost.Output p))
  => r
  -> p
  -> BlogPost.Id r
  -> ActionM ()
getSinglePost r p postId = do
   blogPost <- liftIO $ toMarkup <$> BlogPost.getSinglePost postId r p
   html $ renderHtml $(shamletFile "static/templates/BlogPost.hamlet")

run :: (BlogPost.PersistenceAdapter r, Parsable (BlogPost.Id r)) => r -> IO ()
run r = do
  port <- fromMaybe "3000" <$> lookupEnv "PORT"

  scotty (read port) $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css; charset=utf-8"
      text $ renderCss $ $(cassiusFile "static/templates/Styles.cassius") render

    get "/" $ redirect "/blog"
    get "/blog" $ getAllPosts r (Proxy @HtmlPresenter)
    get "/blog/:id" $ param "id" >>= getSinglePost r (Proxy @HtmlPresenter)
    get "/about" $ html $ renderHtml $(shamletFile "static/templates/About.hamlet")

  where
    render = undefined

