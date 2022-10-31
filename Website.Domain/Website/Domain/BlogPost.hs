{-# LANGUAGE TemplateHaskell #-}
module Website.Domain.BlogPost
(
    Title
  , Content
  , Author
  , Description
  , BlogPostMeta
  , BlogPost
  , makeBlogPostMeta
  , makeBlogPost
  , meta_title
  , meta_author
  , meta_description
  , meta_date
  , bp_meta
  , bp_content
)
where

import           Control.Lens
import           Data.Text       (Text)
import           Data.Time.Clock (UTCTime)

type Title = Text
type Content = Text
type Author = Text
type Description = Text

data BlogPostMeta =
  BlogPostMeta
  { _meta_title       :: Title
  , _meta_author      :: Author
  , _meta_description :: Description
  , _meta_date        :: UTCTime
  }
  deriving Show

makeBlogPostMeta :: Title -> Author -> Description -> UTCTime -> BlogPostMeta
makeBlogPostMeta = BlogPostMeta

data BlogPost = BlogPost
  { _bp_meta    :: BlogPostMeta
  , _bp_content :: Content
  }
  deriving Show

makeBlogPost :: BlogPostMeta -> Content -> BlogPost
makeBlogPost = BlogPost


makeLenses ''BlogPostMeta
makeLenses ''BlogPost
