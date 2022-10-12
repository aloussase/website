{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE FlexibleContexts        #-}
module BlogPost.Internal.Presentation.Class where

import           BlogPost.Internal.Types

import           Control.Monad.IO.Class  (MonadIO)
import           Text.Blaze              (ToMarkup)

class Presenter a where
  type Output a

  -- | 'presentPostMeta' converts a single post's metadata to a textual representation
  -- to be consumed by the view.
  presentPostMeta :: (MonadIO m, ToMarkup (Output a)) => a -> BlogPostMeta -> m (Output a)

  -- | 'presentPost' converts a single post to a textual representation to be
  -- consumed by the view.
  presentPost :: (MonadIO m, ToMarkup (Output a)) => a -> BlogPost -> m (Output a)
