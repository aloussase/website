{-# LANGUAGE FlexibleContexts #-}
module BlogPost.Internal.Interactor.GetAllPosts
(
    GetAllPosts
  , newGetAllPosts
  , getAllPosts
)
where

import           BlogPost.Internal.Ports.PersistenceAdapter
import           BlogPost.Internal.Ports.PresenterAdapter

import           Text.Blaze                                 (ToMarkup)

data GetAllPosts r p = GetAllPosts r p

newGetAllPosts :: (PersistenceAdapter r, PresenterAdapter p) => r -> p -> GetAllPosts r p
newGetAllPosts = GetAllPosts

getAllPosts :: (PersistenceAdapter r, PresenterAdapter p, Monoid (Output p), ToMarkup (Output p)) => GetAllPosts r p -> IO (Output p)
getAllPosts (GetAllPosts repository presenter) = do
  postsWithMeta <- map snd <$> findAll repository
  presentedPosts <- mapM (presentPostMeta presenter) postsWithMeta
  pure $ mconcat presentedPosts
