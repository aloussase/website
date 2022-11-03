module Website.Domain.Service.ProjectFormatter where

import           Website.Domain.Project

import           Control.Monad.IO.Class

-- | Class for things that can format 'Project's.
class ProjectFormatter a where
  type Output a

  -- | 'formatProject' formats a single project.
  formatProject :: (MonadIO m) => a -> Project -> m (Output a)
