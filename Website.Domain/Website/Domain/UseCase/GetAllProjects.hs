module Website.Domain.UseCase.GetAllProjects
(
  getAllProjects
)
 where

import           Website.Domain.Service.ProjectFormatter
import           Website.Domain.Service.ProjectService

import           Control.Monad.IO.Class

getAllProjects :: (MonadIO m, ProjectService s, ProjectFormatter f) => s -> f -> m [Output f]
getAllProjects service formatter = do
  projects <- liftIO $ fetchProjects service
  mapM (formatProject formatter) projects
