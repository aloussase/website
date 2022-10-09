module Web.Internal.View.Pages
(
    renderHomePage
  , renderAboutPage
)
where

import           BlogPost.Component            (bpDate, bpShortDescription,
                                                bpTitle)
import qualified BlogPost.Component            as BlogPost

import           Data.Text.Lazy                (Text)
import           Data.Time.Clock               (UTCTime)
import           Text.Blaze.Html               (ToMarkup (..), string)
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet

instance ToMarkup UTCTime where toMarkup = string . show

renderHomePage :: BlogPost.Component -> IO Text
renderHomePage BlogPost.Component {..} = do
  posts <- BlogPost.findAll bpService bpRepository
  pure $ renderHtml $(shamletFile "static/templates/Home.hamlet")

renderAboutPage :: IO Text
renderAboutPage = pure $ renderHtml $(shamletFile "static/templates/About.hamlet")

navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")
