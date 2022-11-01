{-# LANGUAGE QuasiQuotes #-}
module Website.Infrastructure.HtmlBlogPostFormatter
(
  HtmlBlogPostFormatter
)
where

import           Website.Domain.BlogPost
import           Website.Domain.Service.BlogPostFormatter

import           Control.Lens
import           Control.Monad.IO.Class                   (liftIO)
import           Data.Proxy                               (Proxy)
import           Data.Time.Clock                          (UTCTime)
import           Text.Blaze.Html                          (ToMarkup (..),
                                                           string)
import           Text.Hamlet
import           Text.Pandoc

instance ToMarkup UTCTime where toMarkup = string . show

data HtmlBlogPostFormatter

postToHtml :: BlogPost -> IO Html
postToHtml bp =
  let txt = bp^.bp_content
   in runIOorExplode $ readMarkdown def txt >>= writeHtml5 def

instance BlogPostFormatter (Proxy HtmlBlogPostFormatter) where
  type Output (Proxy HtmlBlogPostFormatter) = Html

  formatPostMeta _ meta = pure [shamlet|
    <article .post-preview>
      <div .post-meta>
          <h2 .post-title><a href="/blog/#{postTitle}">#{postTitle}</a>
          <small .post-date>#{postDate}
      <p .post-description>#{postDescription}
    |]
    where
      postTitle = meta^.meta_title
      postDate = meta^.meta_date
      postDescription = meta^.meta_description

  formatPost _ bp = liftIO $ postToHtml bp
