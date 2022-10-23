module BlogPost.Internal.Repository.FileSystem
(
    Handle
  , newFileSystemRepository
)
where

import           BlogPost.Internal.Repository.Class
import           BlogPost.Internal.Types

import           Control.Monad.IO.Class             (MonadIO, liftIO)
import           Data.Maybe                         (fromMaybe)
import           Data.Text                          (Text)
import qualified Data.Text                          as T
import qualified Data.Text.IO                       as TIO
import           Data.Time.Format                   (defaultTimeLocale,
                                                     parseTimeM,
                                                     parseTimeOrError)
import           System.Directory                   (listDirectory)
import           System.Environment                 (lookupEnv)
import           System.FilePath                    (combine, takeBaseName,
                                                     (<.>))


postsDir :: IO FilePath
postsDir = fromMaybe "static/posts/" <$> lookupEnv "BLOG_POSTS_PATH"

dateFormat :: String
dateFormat = "%d/%m/%Y"

data Handle = Handle

newFileSystemRepository :: IO Handle
newFileSystemRepository = pure Handle

instance Repository Handle where
  type Id Handle = Text
  findAll = findAllPosts
  findById = findPostById

extractMeta :: Text -> Text
extractMeta = last . T.splitOn ":"

findAllPosts :: (MonadIO m) => Handle -> m [(Id Handle, BlogPostMeta)]
findAllPosts _ = do
  basePath <- liftIO postsDir
  postFiles <- map (combine basePath) <$> liftIO (listDirectory basePath)
  let ids = map (T.pack . takeBaseName) postFiles
  traverse (liftIO . uncurry parseBlogPostMeta) (zip ids postFiles)
  where
    parseBlogPostMeta :: Text -> FilePath -> IO (Id Handle, BlogPostMeta)
    parseBlogPostMeta postId postFile = do
      (title:author:tDate:description:_) <- T.lines <$> TIO.readFile postFile
      let meta = makeBlogPostMeta
                  (extractMeta title)
                  (extractMeta author)
                  (extractMeta description)
                  (parseTimeOrError True defaultTimeLocale dateFormat (T.unpack $ extractMeta tDate))
      pure (postId, meta)

findPostById :: (MonadIO m) => Handle -> Id Handle -> m (Maybe BlogPost)
findPostById _ postId = do
  filePath <- flip combine (titleToFilePath postId <.> "md") <$> liftIO postsDir
  parsePost <$> liftIO (TIO.readFile filePath)
  where
    parsePost :: Text -> Maybe BlogPost
    parsePost s = do
      let (title:author:tDate:description:content) = T.lines s
      meta <- makeBlogPostMeta
                (extractMeta title)
                (extractMeta author)
                (extractMeta description)
                <$> parseTimeM True defaultTimeLocale dateFormat (T.unpack $ extractMeta tDate)
      pure $ makeBlogPost meta (T.unlines content)

titleToFilePath :: Text -> FilePath
titleToFilePath = T.unpack . T.toCaseFold . T.strip
