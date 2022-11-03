{-# LANGUAGE QuasiQuotes #-}
module Website.Infrastructure.HtmlProjectFormatter (HtmlProjectFormatter) where

import           Website.Domain.Project
import           Website.Domain.Service.ProjectFormatter

import           Control.Monad.IO.Class
import           Data.Proxy                              (Proxy)
import           Text.Hamlet
import           Text.URI


data HtmlProjectFormatter

instance ProjectFormatter (Proxy HtmlProjectFormatter) where
  type Output (Proxy HtmlProjectFormatter) = Html

  formatProject = _formatProject


_formatProject :: (MonadIO m) => Proxy HtmlProjectFormatter -> Project -> m (Output (Proxy HtmlProjectFormatter))
_formatProject _ project = pure [shamlet|
  <div .project-card>
    <h2 .project-name>#{unProjectName $ projectName project}
    <span .project-description>#{unProjectDescription $ projectDescription project}
    <span .project-link>
      <a href=#{render $ projectUri project} target="_blank">Learn more
  |]



