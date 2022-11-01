{-# LANGUAGE ScopedTypeVariables #-}
module Website.Application.BlogPostQueryApiHandler
(
  queryHandler
)
where

import           Website.Application.BlogPostQueries
import           Website.Domain.Repository.BlogPostRepository
import           Website.Domain.Service.BlogPostFormatter
import           Website.Domain.UseCase.GetAllPosts
import           Website.Domain.UseCase.GetSinglePost

import           Control.Monad.IO.Class
import           Text.Blaze.Html

queryHandler :: (BlogPostRepository r, BlogPostFormatter p, ToMarkup (Output p)) => r -> p -> Query (Id r) -> IO Markup
queryHandler r p (GetSinglePost id) = onGetSinglePost r p id
queryHandler r p GetAllPosts        = onGetAllPosts r p

onGetSinglePost ::
  (BlogPostRepository r, BlogPostFormatter p, ToMarkup (Output p), MonadIO m) =>
  r ->
  p ->
  Id r ->
  m Markup
onGetSinglePost r p postId = liftIO (toMarkup <$> getSinglePost postId r p)

onGetAllPosts ::
  (BlogPostRepository r, BlogPostFormatter p, ToMarkup (Output p), MonadIO m) =>
  r ->
  p ->
  m Markup
onGetAllPosts r p = liftIO (toMarkup <$> getAllPosts r p)

