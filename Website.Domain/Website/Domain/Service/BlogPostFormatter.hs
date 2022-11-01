{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE FlexibleContexts        #-}
module Website.Domain.Service.BlogPostFormatter where

import           Website.Domain.BlogPost

import           Control.Monad.IO.Class  (MonadIO)

class (Monoid (Output a)) => BlogPostFormatter a where
  type Output a

  -- | 'presentPostMeta' converts a single post's metadata to a textual representation
  -- to be consumed by the view.
  formatPostMeta :: (MonadIO m) => a -> BlogPostMeta -> m (Output a)

  -- | 'presentPost' converts a single post to a textual representation to be
  -- consumed by the view.
  formatPost :: (MonadIO m) => a -> BlogPost -> m (Output a)
