{-# LANGUAGE FlexibleContexts #-}
module Website.Domain.Repository.BlogPostRepository where

import           Website.Domain.BlogPost (BlogPost, BlogPostMeta)

import           Control.Monad.IO.Class  (MonadIO)


-- | An interface for things that can act as blog post store.
class BlogPostRepository a where
  -- | The type of values that uniquely identify blog posts.
  type Id a

  -- | Get all the blog posts in this repository.
  findAll :: (MonadIO m) => a -> m [(Id a, BlogPostMeta)]

  -- | Find the blog post for the corresponding id.
  findById :: (MonadIO m) => a -> Id a -> m (Maybe BlogPost)
