module BlogPost.Internal.Repository.InMemory
(
    Handle
  , Id
  , close
  , create
  , deleteById
  , findById
  , new
)
where

import           BlogPost.Internal.Repository
import           BlogPost.Internal.Types

import           Data.IORef
import           Data.Map                     (Map)
import qualified Data.Map                     as M

-- TODO:
--
--  If I'm going to use this implementation in production I should use a
--  TVar instead of an IORef.
--
data Handle = Handle (IORef (Map Int BlogPost))

-- | Create a new handle to an in memory repository.
new :: IO Handle
new = Handle <$> newIORef M.empty

-- | Close the provided handle, disposing of any acquired resources.
close :: Handle -> IO ()
close = const $ pure ()

instance Repository Handle where
  type Id Handle = Int
  create = createPost
  findAll = findAllPosts
  findById = findPostById
  deleteById = deletePostById

createPost :: Handle -> NewBlogPost -> IO BlogPost
createPost = undefined

findAllPosts :: Handle -> IO [BlogPost]
findAllPosts =  const $ pure []

findPostById :: Handle -> Id Handle -> IO (Maybe BlogPost)
findPostById = undefined

deletePostById :: Handle -> Id Handle -> IO ()
deletePostById = undefined


