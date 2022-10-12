{-# LANGUAGE FlexibleContexts #-}
module BlogPost.Internal.Interactor.GetAllPosts
(
    GetAllPosts
  , newGetAllPosts
  , getAllPosts
)
where

import           BlogPost.Internal.Presentation.Class
import           BlogPost.Internal.Repository.Class

import           Text.Blaze                           (ToMarkup)

data GetAllPosts r p = GetAllPosts r p

newGetAllPosts :: (Repository r, Presenter p) => r -> p -> GetAllPosts r p
newGetAllPosts = GetAllPosts

getAllPosts :: (Repository r, Presenter p, Monoid (Output p), ToMarkup (Output p)) => GetAllPosts r p -> IO (Output p)
getAllPosts (GetAllPosts repository presenter) = do
  postsWithMeta <- map snd <$> findAll repository
  presentedPosts <- mapM (presentPostMeta presenter) postsWithMeta
  pure $ mconcat presentedPosts
