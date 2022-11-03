module Website.Application.BlogPostQueries where

import           Website.Domain.Repository.BlogPostRepository

data Query repository = GetSinglePost repository (Id repository) | GetAllPosts repository
