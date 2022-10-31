{-# LANGUAGE ScopedTypeVariables #-}
module Website.Application.QueryApiHandler
(
  queryHandler
)
where

import           Website.Application.Queries
import           Website.Domain.BlogPostPresenter
import           Website.Domain.BlogPostRepository
import qualified Website.Domain.GetAllPosts        as GetAllPosts
import           Website.Domain.GetSinglePost

import           Control.Monad.IO.Class
import           Text.Blaze.Html

queryHandler :: (BlogPostRepository r, BlogPostPresenter p, ToMarkup (Output p)) => r -> p -> Query (Id r) -> IO Markup
queryHandler r p (GetSinglePost id) = onGetSinglePost r p id
queryHandler r p GetAllPosts        = onGetAllPosts r p

onGetSinglePost ::
  (BlogPostRepository r, BlogPostPresenter p, ToMarkup (Output p), MonadIO m) =>
  r ->
  p ->
  Id r ->
  m Markup
onGetSinglePost r p postId = liftIO (toMarkup <$> getSinglePost postId r p)

onGetAllPosts ::
  (BlogPostRepository r, BlogPostPresenter p, ToMarkup (Output p), MonadIO m) =>
  r ->
  p ->
  m Markup
onGetAllPosts r p = do
  let getAllPostsUseCase = GetAllPosts.newGetAllPosts r p
  liftIO (toMarkup <$> GetAllPosts.getAllPosts getAllPostsUseCase)

