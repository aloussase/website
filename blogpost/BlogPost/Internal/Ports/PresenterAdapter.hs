{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE FlexibleContexts        #-}
module BlogPost.Internal.Ports.PresenterAdapter where

import           BlogPost.Internal.Entities

import           Control.Monad.IO.Class     (MonadIO)

class (Monoid (Output a)) => PresenterAdapter a where
  type Output a

  -- | 'presentPostMeta' converts a single post's metadata to a textual representation
  -- to be consumed by the view.
  presentPostMeta :: (MonadIO m) => a -> BlogPostMeta -> m (Output a)

  -- | 'presentPost' converts a single post to a textual representation to be
  -- consumed by the view.
  presentPost :: (MonadIO m) => a -> BlogPost -> m (Output a)
