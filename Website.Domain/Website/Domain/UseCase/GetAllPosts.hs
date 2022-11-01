module Website.Domain.UseCase.GetAllPosts
(
  getAllPosts
)
where

import           Website.Domain.Repository.BlogPostRepository
import           Website.Domain.Service.BlogPostFormatter

getAllPosts :: (BlogPostRepository r, BlogPostFormatter p) => r -> p -> IO (Output p)
getAllPosts repository presenter = do
  postsWithMeta <- map snd <$> findAll repository
  presentedPosts <- mapM (formatPostMeta presenter) postsWithMeta
  pure $ mconcat presentedPosts
