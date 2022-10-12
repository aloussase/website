{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies      #-}
module Web.Internal.View.HtmlPresenter where

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
          <h2 .post-title>#{postTitle}
          <small .post-date>#{postDate}
      <p .post-description>#{postDescription}
    |]
    where
      postTitle = meta^.meta_title
      postDate = meta^.meta_date
      postDescription = meta^.meta_description

  presentPost _ bp = pure [shamlet||]

