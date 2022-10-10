module BlogPost.Internal.Repository.InMemory
(
    Handle
  , Id
  , close
  , findById
  , new
)
where

import           BlogPost.Internal.Repository
import           BlogPost.Internal.Types

import           Control.Monad.IO.Class       (MonadIO, liftIO)
import           Data.IORef
import           Data.Map                     (Map, (!?))
import qualified Data.Map                     as M

-- TODO:
--
--  If I'm going to use this implementation in production I should use a
--  TVar instead of an IORef.
--
newtype Handle = Handle (IORef (Map Int BlogPost))

-- | Create a new handle to an in memory repository.
new :: IO Handle
new = Handle <$> newIORef M.empty

-- | Close the provided handle, disposing of any acquired resources.
close :: Handle -> IO ()
close = const $ pure ()

instance Repository Handle where
  type Id Handle = Int
  findAll = findAllPosts
  findById = findPostById

findAllPosts :: (MonadIO m) => Handle -> m [BlogPostInfo (Id Handle)]
findAllPosts _ = undefined

findPostById :: (MonadIO m) => Handle -> Id Handle -> m (Maybe BlogPost)
findPostById (Handle m) postId = do
  m' <- liftIO $ readIORef m
  pure $ m' !? postId
