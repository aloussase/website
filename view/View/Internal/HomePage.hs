module View.Internal.HomePage
(
  renderHomePage
)
where

import           View.Internal.Navbar

import           BlogPost.Component            (bpDate, bpShortDescription,
                                                bpTitle)
import qualified BlogPost.Component            as BlogPost

import           Data.Text.Lazy                (Text)
import           Data.Time.Clock               (UTCTime)
import           Text.Blaze.Html               (ToMarkup (..), string)
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet


instance ToMarkup UTCTime where toMarkup = string . show

renderHomePage :: (BlogPost.Service s, BlogPost.Repository r) => s -> r -> IO Text
renderHomePage service repository = do
  posts <- BlogPost.findAll service repository
  pure $ renderHtml $(shamletFile "static/templates/Home.hamlet")
