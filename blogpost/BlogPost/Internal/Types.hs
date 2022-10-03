module BlogPost.Internal.Types where

import           Data.Text       (Text)
import           Data.Time.Clock (UTCTime)

type Title = Text
type Content = Text
type Author = Text

data BlogPost =
  BlogPost
  { bpTitle            :: Text
  , bpAuthor           :: Text
  , bpShortDescription :: Text
  , bpDate             :: UTCTime
  , bpContent          :: Text
  }
  deriving Show
