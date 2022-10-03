module View.Internal.AboutPage (renderAboutPage) where

import           View.Internal.Navbar

import           Data.Text.Lazy                (Text)
import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet


renderAboutPage :: IO Text
renderAboutPage = pure $ renderHtml $(shamletFile "static/templates/About.hamlet")
