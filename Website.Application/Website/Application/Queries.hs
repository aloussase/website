module Website.Application.Queries where

data Query id =
  GetSinglePost id
  | GetAllPosts
  deriving Show
