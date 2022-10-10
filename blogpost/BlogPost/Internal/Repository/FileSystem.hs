module BlogPost.Internal.Repository.FileSystem
(
    Handle
  , new
)
where

import           BlogPost.Internal.Repository
import           BlogPost.Internal.Types

import           Control.Monad.IO.Class       (MonadIO, liftIO)
import           Data.Maybe                   (fromMaybe)
import           Data.Text                    (Text)
import qualified Data.Text                    as T
import qualified Data.Text.IO                 as TIO
import           Data.Time.Format             (defaultTimeLocale, parseTimeM,
                                               parseTimeOrError)
import           System.Directory             (listDirectory)
import           System.Environment           (lookupEnv)
import           System.FilePath              (combine, takeBaseName, (<.>))


postsDir :: IO FilePath
postsDir = fromMaybe "static/posts/" <$> lookupEnv "BLOG_POSTS_PATH"

dateFormat :: String
dateFormat = "%d/%m/%Y"

data Handle = Handle

new :: IO Handle
new = pure Handle

instance Repository Handle where
  type Id Handle = Text
  findAll = findAllPosts
  findById = findPostById

extractMeta :: Text -> Text
extractMeta = last . T.splitOn ":"

findAllPosts :: (MonadIO m) => Handle -> m [BlogPostInfo (Id Handle)]
findAllPosts _ = do
  basePath <- liftIO postsDir
  postFiles <- map (combine basePath) <$> liftIO (listDirectory basePath)
  let ids = map (T.pack . takeBaseName) postFiles
  traverse (liftIO . uncurry parseBlogPostInfo) (zip ids postFiles)
  where
    parseBlogPostInfo :: Text -> FilePath -> IO (BlogPostInfo (Id Handle))
    parseBlogPostInfo postId postFile = do
      (title:author:tDate:description:_) <- T.lines <$> TIO.readFile postFile
      pure $ BlogPostInfo
        { infoId = postId
        , infoTitle = extractMeta title
        , infoAuthor = extractMeta author
        , infoDate = parseTimeOrError
                        True
                        defaultTimeLocale
                        dateFormat
                        (T.unpack $ extractMeta tDate)
        , infoDescription = extractMeta description
        }


findPostById :: (MonadIO m) => Handle -> Id Handle -> m (Maybe BlogPost)
findPostById _ postId = do
  filePath <- flip combine (T.unpack postId <.> "md") <$> liftIO postsDir
  parsePost <$> liftIO (TIO.readFile filePath)
  where
    parsePost :: Text -> Maybe BlogPost
    parsePost s = do
      let (title:author:tDate:description:content) = T.lines s
      date <- parseTimeM True defaultTimeLocale dateFormat (T.unpack $ extractMeta tDate)
      pure $ BlogPost
        { bpTitle = extractMeta title
        , bpAuthor = extractMeta author
        , bpDate = date
        , bpDescription = extractMeta description
        , bpContent = T.unlines content
        }

