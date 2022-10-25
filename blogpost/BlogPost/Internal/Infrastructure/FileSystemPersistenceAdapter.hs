{-# LANGUAGE TupleSections #-}
module BlogPost.Internal.Infrastructure.FileSystemPersistenceAdapter
(
    Handle
  , newFileSystemRepository
)
where

import           BlogPost.Internal.Entities
import           BlogPost.Internal.Ports.PersistenceAdapter

import           Control.Monad.IO.Class                     (MonadIO, liftIO)
import           Data.Attoparsec.Text
import           Data.Either.Combinators                    (rightToMaybe)
import           Data.Maybe                                 (fromMaybe)
import           Data.Text                                  (Text)
import qualified Data.Text                                  as T
import qualified Data.Text.IO                               as TIO
import           Data.Time                                  (UTCTime)
import           Data.Time.Format                           (defaultTimeLocale,
                                                             parseTimeM)
import           System.Directory                           (listDirectory)
import           System.Environment                         (lookupEnv)
import           System.FilePath                            (combine,
                                                             takeBaseName,
                                                             (<.>))


postsDir :: IO FilePath
postsDir = fromMaybe "static/posts/" <$> lookupEnv "BLOG_POSTS_PATH"

dateFormat :: String
dateFormat = "%d/%m/%Y"

parseTextField :: Text -> Parser Text
parseTextField fieldName = T.pack <$> (parseFieldName *> parseField <* parseEol)
  where
    parseFieldName = string fieldName >> char ':' >> skipSpace <?> ("field name: " <> T.unpack fieldName)
    parseField = many1 (notChar '\n') <?> "field value"
    parseEol = endOfLine <?> "end of line"

parseTitle :: Parser Text
parseTitle = parseTextField "title" <?> "title"

parseAuthor :: Parser Text
parseAuthor = parseTextField "author" <?> "author"

parseDate :: Parser UTCTime
parseDate = do
  dateString <- T.unpack <$> parseTextField "date" <?> "date"
  parseTimeM True defaultTimeLocale dateFormat dateString

parseDescription :: Parser Text
parseDescription = parseTextField "description" <?> "description"

parseBlogPostMeta :: Parser BlogPostMeta
parseBlogPostMeta = makeBlogPostMeta
                <$> parseTitle
                <*> parseAuthor
                <*> parseDescription
                <*> parseDate
                <?> "parseBlogPostMeta"

extractBlogPostMeta :: Text -> Either String (BlogPostMeta, Text)
extractBlogPostMeta txt = do
  let (meta, contents) = T.breakOn "---" txt
  parseResult <- eitherResult $ parse parseBlogPostMeta meta
  pure (parseResult, T.unlines . drop 1 . T.lines $ contents)

data Handle = Handle

newFileSystemRepository :: IO Handle
newFileSystemRepository = pure Handle

instance PersistenceAdapter Handle where
  type Id Handle = Text
  findAll = findAllPosts
  findById = findPostById

findAllPosts :: (MonadIO m) => Handle -> m [(Id Handle, BlogPostMeta)]
findAllPosts _ = do
  basePath <- liftIO postsDir
  postFiles <- map (combine basePath) <$> liftIO (listDirectory basePath)
  let ids = map (T.pack . takeBaseName) postFiles
  traverse (liftIO . uncurry processFile) (zip ids postFiles)
  where
    -- TODO: Handle error here.
    processFile :: Text -> FilePath -> IO (Id Handle, BlogPostMeta)
    processFile postId postFilePath = do
      fileContents <- TIO.readFile postFilePath
      case parseBlogPostMeta postId fileContents of
        Right result -> pure result
        Left err     -> error err

    parseBlogPostMeta :: Text -> Text -> Either String (Id Handle, BlogPostMeta)
    parseBlogPostMeta postId fileContents = (postId, ) . fst <$> extractBlogPostMeta fileContents

findPostById :: (MonadIO m) => Handle -> Id Handle -> m (Maybe BlogPost)
findPostById _ postId = do
  filePath <- flip combine (titleToFilePath postId <.> "md") <$> liftIO postsDir
  fileContents <- liftIO $ TIO.readFile filePath
  pure $ uncurry makeBlogPost <$> rightToMaybe (extractBlogPostMeta fileContents)

titleToFilePath :: Text -> FilePath
titleToFilePath = T.unpack . T.toCaseFold . T.strip
