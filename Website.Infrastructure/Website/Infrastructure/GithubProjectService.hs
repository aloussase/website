{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Website.Infrastructure.GithubProjectService (GithubProjectService) where

import           Website.Domain.Project
import           Website.Domain.Service.ProjectService

import           Control.Exception
import           Control.Monad.IO.Class
import           Data.Aeson
import           Data.Map                              (Map)
import qualified Data.Map                              as M
import           Data.Proxy
import           Data.Text                             (Text)
import qualified Data.Text                             as T
import           Network.HTTP.Req
import           Website.Domain.DomainException

apiUrl :: Text -> Url 'Https
apiUrl username =
  --     api.github.com  /   users  /  aloussase /   repos
  https "api.github.com" /: "users" /: username  /: "repos"

data GithubProjectService

instance ProjectService (Proxy GithubProjectService) where
  fetchProjects = _getProjects


_getProjects :: (MonadIO m) => Proxy GithubProjectService -> m [Project]
_getProjects _ =  liftIO $ runReq defaultHttpConfig $ do
  r :: JsonResponse [Map Text Value] <-
    req
      GET
      (apiUrl "aloussase")
      NoReqBody
      jsonResponse
      (header "User-Agent" "req/1.0")
  either
    (liftIO . throwIO . ValidationException . mconcat)
    pure
    (concatEithers $ map extractProjectData $ responseBody r)

concatEithers :: (Monoid a, Monoid b) => [Either a b] -> Either a b
concatEithers [] = pure mempty
concatEithers eithers = go (tail eithers) (head eithers)
  where
    go :: (Monoid a, Monoid b) => [Either a b] -> Either a b -> Either a b
    go (Right r:es) (Right rs)   = go es $ pure (r <> rs)
    go (Left err:es) (Left errs) = go es $ Left (err <> errs)
    go (Left err:es) (Right _)   = go es $ Left err
    go (Right _:es) (Left err)   = go es $ Left err
    go _ result                  = result

extractProjectData :: Map Text Value -> Either [Text] [Project]
extractProjectData repoData =
  let name = decodeOrError $ unwrapField repoData "name"
      desc = decodeOrError $ unwrapField repoData "description"
      uri = decodeOrError $ unwrapField repoData "html_url"
   in pure <$> mkProject name desc uri

unwrapField :: Map Text Value -> Text -> Value
unwrapField m k = case M.lookup k m of
                Just t -> t
                _      -> throwMissingFields' [k]

decodeOrError :: (FromJSON a) => Value -> a
decodeOrError v = case fromJSON v of
                    Success r -> r
                    Error msg -> throwParseException' $ T.pack msg
