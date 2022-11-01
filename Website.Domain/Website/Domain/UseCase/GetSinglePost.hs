{-# LANGUAGE FlexibleContexts #-}

module Website.Domain.UseCase.GetSinglePost where

import           Website.Domain.Repository.BlogPostRepository
import           Website.Domain.Service.BlogPostFormatter

-- | 'getSinglePost' return a formatted 'BlogPost' given the corresponding post id.
getSinglePost :: (BlogPostRepository r, BlogPostFormatter p)
  => Id r
  -> r
  -> p
  -> IO (Output p)
getSinglePost id r p = do
  singlePost <- findById r id
  maybe mempty (formatPost p) singlePost
