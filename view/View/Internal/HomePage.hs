module View.Internal.HomePage
(
  renderHomePage
)
where

import           View.Internal.Navbar

import qualified BlogPost.Component            as BlogPost

import           Data.Text.Lazy                (Text)
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet


renderHomePage :: (BlogPost.Service s, BlogPost.Repository r) => s -> r -> IO Text
renderHomePage service repository = do
  posts <- BlogPost.findAll service repository
  pure $ renderHtml $(shamletFile "static/templates/Home.hamlet")
