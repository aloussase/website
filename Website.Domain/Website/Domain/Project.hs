{-# LANGUAGE ScopedTypeVariables #-}
module Website.Domain.Project
(
    Project
  , mkProject
  , projectName
  , projectDescription
  , projectUri
)
where

import           Control.Monad           (join)
import           Control.Monad.Catch     (try)
import           Data.Either.Combinators (rightToMaybe)
import           Data.Text               (Text)
import qualified Data.Text               as T
import           Data.Validation
import           Text.URI                (URI, mkURI)

newtype ProjectName = ProjectName Text deriving Show
newtype ProjectDescription = ProjectDescription Text deriving Show

data Project = Project
  { projectName        :: ProjectName
  , projectDescription :: ProjectDescription
  , projectUri         :: URI
  }
  deriving Show

mkProject :: Text -> Text -> Text -> Either [Text] Project
mkProject name desc uri = toEither $ Project
  <$> validateProjectName name
  <*> validateProjectDescription desc
  <*> validateProjectUri uri

type ProjectValidation = Validation [Text]

validateNonEmptyTxt :: Text -> Text ->  ProjectValidation Text
validateNonEmptyTxt errMsg = validate [errMsg] f
  where
    f txt =
      let txt' = T.strip txt
       in if not $ T.null txt'
             then pure txt'
             else Nothing

validateProjectName :: Text -> ProjectValidation ProjectName
validateProjectName txt =
  ProjectName <$> validateNonEmptyTxt "Project name must be non-empty" txt

validateProjectDescription :: Text -> ProjectValidation ProjectDescription
validateProjectDescription txt =
  ProjectDescription <$> validateNonEmptyTxt "Project description must be non-empty" txt

validateProjectUri :: Text -> ProjectValidation URI
validateProjectUri uri = validateNonEmptyTxt "Project uri must be non-empty" uri
                      *> validate ["Invalid project uri"] (rightToMaybe . join . try . mkURI) uri
