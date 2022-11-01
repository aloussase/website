module Website.Application (run) where

import           Website.Application.BlogPostQueries
import           Website.Application.BlogPostQueryApiHandler  (queryHandler)
import           Website.Domain.Repository.BlogPostRepository
import           Website.Infrastructure.HtmlBlogPostFormatter

import           Control.Monad.IO.Class
import           Data.Data                                    (Proxy (..))
import           Data.Maybe                                   (fromMaybe)
import           System.Environment                           (lookupEnv)
import           Text.Blaze.Html.Renderer.Text
import           Text.Cassius
import           Text.Hamlet
import           Web.Scotty


navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")

footer :: Html
footer = $(shamletFile "static/templates/Footer.hamlet")

run :: (BlogPostRepository r, Parsable (Id r)) => r -> IO ()
run r = do
  port <- fromMaybe "3000" <$> lookupEnv "PORT"

  scotty (read port) $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css; charset=utf-8"
      text $ renderCss $ $(cassiusFile "static/templates/Styles.cassius") render

    get "/" $ redirect "/blog"
    get "/blog" $ do
      posts <- liftIO $ queryHandler r (Proxy @HtmlBlogPostFormatter) GetAllPosts
      html $ renderHtml $(shamletFile "static/templates/Home.hamlet")

    get "/blog/:id" $ param "id" >>= \postId -> do
      blogPost <- liftIO $ queryHandler r (Proxy @HtmlBlogPostFormatter) (GetSinglePost postId)
      html $ renderHtml $(shamletFile "static/templates/BlogPost.hamlet")

    get "/about" $ html $ renderHtml $(shamletFile "static/templates/About.hamlet")
  where
    render = undefined
