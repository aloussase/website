module Website.Application.BlogPostQueries where

data Query id =
  GetSinglePost id
  | GetAllPosts
  deriving Show
