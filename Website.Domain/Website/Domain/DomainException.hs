module Website.Domain.DomainException where

import           Control.Exception
import           Data.Text


data DomainException =
  ParseException Text
  | MalformedRequest
  | GenericException Text
  | MissingFields [Text]
  | ValidationException Text
  deriving Show

instance Exception DomainException

throwGeneric :: Text -> IO ()
throwGeneric = throwIO  . GenericException

throwParseException :: Text -> IO ()
throwParseException = throwIO . ParseException

throwParseException' :: Text -> a
throwParseException' = throw . ParseException

throwMissingFields :: [Text] -> IO ()
throwMissingFields = throwIO . MissingFields

throwMissingFields' :: [Text] -> a
throwMissingFields' =  throw . MissingFields
