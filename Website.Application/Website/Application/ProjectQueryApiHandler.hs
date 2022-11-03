module Website.Application.ProjectQueryApiHandler where

import           Website.Application.Common
import           Website.Application.ProjectQueries
import           Website.Domain.UseCase.GetAllProjects       (getAllProjects)
import           Website.Infrastructure.GithubProjectService
import           Website.Infrastructure.HtmlProjectFormatter

import           Control.Monad.IO.Class
import           Data.Data                                   (Proxy (Proxy))
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet
import           Web.Scotty

projectQueryHandler :: QueryHandler ActionM Query ()
projectQueryHandler GetAllProjects = do
  projects <- liftIO $ mconcat <$> getAllProjects (Proxy @GithubProjectService) (Proxy @HtmlProjectFormatter)
  html $ renderHtml $(shamletFile "static/templates/Projects.hamlet")
