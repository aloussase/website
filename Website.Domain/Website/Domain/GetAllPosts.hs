{-# LANGUAGE FlexibleContexts #-}
module Website.Domain.GetAllPosts
(
    GetAllPosts
  , newGetAllPosts
  , getAllPosts
)
where

import           Website.Domain.BlogPostRepository
import           Website.Domain.BlogPostPresenter

data GetAllPosts r p = GetAllPosts r p

newGetAllPosts :: (BlogPostRepository r, BlogPostPresenter p) => r -> p -> GetAllPosts r p
newGetAllPosts = GetAllPosts

getAllPosts :: (BlogPostRepository r, BlogPostPresenter p) => GetAllPosts r p -> IO (Output p)
getAllPosts (GetAllPosts repository presenter) = do
  postsWithMeta <- map snd <$> findAll repository
  presentedPosts <- mapM (presentPostMeta presenter) postsWithMeta
  pure $ mconcat presentedPosts
