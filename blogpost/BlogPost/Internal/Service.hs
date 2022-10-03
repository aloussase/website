module BlogPost.Internal.Service where

import           BlogPost.Internal.Repository
import           BlogPost.Internal.Types

import           Control.Monad.IO.Class       (MonadIO)

class Service a where
  -- | Find all blog posts.
  findAll :: (Repository r, MonadIO m) => a -> r -> m [BlogPost]

  -- | Find a blog post by id using a given repository.
  findById :: (Repository r, MonadIO m) => a -> r -> (Id r) -> m (Maybe BlogPost)
