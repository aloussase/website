module BlogPost.Internal.Repository where

import           BlogPost.Internal.Types (Author, BlogPost, Title)

import           Control.Monad.IO.Class  (MonadIO)
import           Data.Text               (Text)
import           Data.Time.Clock         (UTCTime)

data BlogPostInfo a =
  BlogPostInfo
  { infoId          :: a
  , infoTitle       :: Title
  , infoAuthor      :: Author
  , infoDescription :: Text
  , infoDate        :: UTCTime
  }
  deriving Show

-- | An interface for things that can act as blog post store.
class Repository a where
  -- | The type of values that uniquely identify blog posts.
  type Id a

  -- | Get all the blog posts in this repository.
  findAll :: (MonadIO m) => a -> m [BlogPostInfo (Id a)]

  -- | Find the blog post for the corresponding id.
  findById :: (MonadIO m) => a -> Id a -> m (Maybe BlogPost)
