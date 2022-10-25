{-# LANGUAGE FlexibleContexts #-}

module BlogPost.Internal.Interactor.GetSinglePost where

import           BlogPost.Internal.Ports.PersistenceAdapter
import           BlogPost.Internal.Ports.PresenterAdapter

import           Text.Blaze                                 (ToMarkup)

-- | 'getSinglePost' return a formatted 'BlogPost' given the corresponding post id.
getSinglePost :: (PersistenceAdapter r, PresenterAdapter p, Monoid (Output p), ToMarkup (Output p))
  => Id r
  -> r
  -> p
  -> IO (Output p)
getSinglePost id r p = do
  singlePost <- findById r id
  maybe mempty (presentPost p) singlePost
