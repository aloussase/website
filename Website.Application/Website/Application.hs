module Website.Application (run) where

import qualified Website.Application.BlogPostQueries          as BlogPostQueries
import           Website.Application.BlogPostQueryApiHandler
import           Website.Application.Common
import qualified Website.Application.ProjectQueries           as ProjectQueries
import           Website.Application.ProjectQueryApiHandler   (projectQueryHandler)
import           Website.Domain.Repository.BlogPostRepository

import           Data.Maybe                                   (fromMaybe)
import           System.Environment                           (lookupEnv)
import           Text.Blaze.Html.Renderer.Text
import           Text.Cassius
import           Text.Hamlet
import           Web.Scotty


run :: (BlogPostRepository r, Parsable (Id r)) => r -> IO ()
run r = do
  port <- fromMaybe "3000" <$> lookupEnv "PORT"

  scotty (read port) $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css; charset=utf-8"
      text $ renderCss $ $(cassiusFile "static/templates/Styles.cassius") render
    get "/" $ redirect "/blog"
    get "/blog" (blogPostQueryHandler ! BlogPostQueries.GetAllPosts r)
    get "/blog/:id" $ param "id" >>= \postId -> blogPostQueryHandler ! BlogPostQueries.GetSinglePost r postId
    get "/projects"  (projectQueryHandler ! ProjectQueries.GetAllProjects)
    get "/about" $ html $ renderHtml $(shamletFile "static/templates/About.hamlet")
  where
    render = undefined
