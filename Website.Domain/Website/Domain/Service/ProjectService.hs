module Website.Domain.Service.ProjectService where

import           Website.Domain.Project

import           Control.Monad.IO.Class (MonadIO)


class ProjectService a where

  -- | 'fetchProjects' Fetches all projects.
  fetchProjects :: (MonadIO m) => a -> m [Project]
