{-# LANGUAGE ScopedTypeVariables #-}
module Website.Application.BlogPostQueryApiHandler
(
  blogPostQueryHandler
  , (!)
)
where

import           Website.Application.BlogPostQueries
import           Website.Application.Common
import           Website.Domain.Repository.BlogPostRepository
import           Website.Domain.UseCase.GetAllPosts
import           Website.Domain.UseCase.GetSinglePost
import           Website.Infrastructure.HtmlBlogPostFormatter

import           Control.Monad.IO.Class
import           Data.Proxy
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet
import           Web.Scotty

blogPostQueryHandler :: (BlogPostRepository repository) => QueryHandler ActionM Query repository

blogPostQueryHandler (GetSinglePost repository id) = do
  blogPost <- liftIO $ getSinglePost id repository (Proxy @HtmlBlogPostFormatter)
  html $ renderHtml $(shamletFile "static/templates/BlogPost.hamlet")

blogPostQueryHandler (GetAllPosts blogPostRepository) = do
  posts <- liftIO $ getAllPosts blogPostRepository (Proxy @HtmlBlogPostFormatter)
  html $ renderHtml $(shamletFile "static/templates/Home.hamlet")

