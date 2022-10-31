{-# LANGUAGE FlexibleContexts #-}

module Website.Domain.GetSinglePost where

import           Website.Domain.BlogPostRepository
import           Website.Domain.BlogPostPresenter

-- | 'getSinglePost' return a formatted 'BlogPost' given the corresponding post id.
getSinglePost :: (BlogPostRepository r, BlogPostPresenter p)
  => Id r
  -> r
  -> p
  -> IO (Output p)
getSinglePost id r p = do
  singlePost <- findById r id
  maybe mempty (presentPost p) singlePost
