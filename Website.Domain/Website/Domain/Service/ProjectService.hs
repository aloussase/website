module Website.Domain.Service.ProjectService where

import           Website.Domain.Project

import           Control.Monad.IO.Class (MonadIO)


class ProjectService a where

  -- | 'fetchProjects' Fetches all projects and returns a list of them or a list
  -- with any encountered errors.
  --
  -- This method may throw an exception of type 'DomainException'.
  --
  fetchProjects :: (MonadIO m) => a -> m [Project]

