{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}
module Web.Internal.View.HtmlPresenter
(
  HtmlPresenter
)
where

import           BlogPost.Component

import           Control.Lens
import           Data.Proxy         (Proxy)
import           Data.Time.Clock    (UTCTime)
import           Text.Blaze.Html    (ToMarkup (..), string)
import           Text.Hamlet


instance ToMarkup UTCTime where toMarkup = string . show

data HtmlPresenter

instance Presenter (Proxy HtmlPresenter) where
  type Output (Proxy HtmlPresenter) = Html

  presentPostMeta _ meta = pure [shamlet|
    <article .post-preview>
      <div .post-meta>
          <h2 .post-title><a href="http://localhost:3000/blog/#{postTitle}">#{postTitle}</a>
          <small .post-date>#{postDate}
      <p .post-description>#{postDescription}
    |]
    where
      postTitle = meta^.meta_title
      postDate = meta^.meta_date
      postDescription = meta^.meta_description

  presentPost _ bp = pure [shamlet|
    <article .blogpost>
      <h1>#{postTitle}
      <p>#{postContent}
    |]
    where
      postTitle = bp^.bp_meta.meta_title
      postContent = bp^.bp_content
