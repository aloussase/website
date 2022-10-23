{-# LANGUAGE FlexibleContexts #-}

module BlogPost.Internal.Interactor.GetSinglePost where

import           BlogPost.Internal.Presentation.Class
import           BlogPost.Internal.Repository.Class

import           Text.Blaze                           (ToMarkup)

-- | 'getSinglePost' return a formatted 'BlogPost' given the corresponding post id.
getSinglePost :: (Repository r, Presenter p, Monoid (Output p), ToMarkup (Output p))
  => Id r
  -> r
  -> p
  -> IO (Output p)
getSinglePost id r p = do
  singlePost <- findById r id
  maybe mempty (presentPost p) singlePost
