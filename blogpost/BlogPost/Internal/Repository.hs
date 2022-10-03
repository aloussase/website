module BlogPost.Internal.Repository where

import           BlogPost.Internal.Types (BlogPost)
import qualified BlogPost.Internal.Types as BlogPost

data NewBlogPost =
  NewBlogPost
  { nbpTitle   :: BlogPost.Title
  , nbpAuthor  :: BlogPost.Author
  , nbpContent :: BlogPost.Content
  }
  deriving Show

-- | An interface for things that can act as blog post store.
class Repository a where
  -- | The type of values that uniquely identify blog posts.
  type Id a

  -- | Create a new blog post.
  create :: a -> NewBlogPost -> IO BlogPost

  -- | Get all the blog post in this repository.
  findAll :: a -> IO [BlogPost]

  -- | Find the blog post for the corresponding id.
  findById :: a -> Id a -> IO (Maybe BlogPost)

  -- | Delete a blog post by its id.
  deleteById :: a -> Id a -> IO ()
