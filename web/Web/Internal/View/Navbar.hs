module Web.Internal.View.Navbar where

import           Text.Blaze.Html.Renderer.Text
import           Text.Hamlet


navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")
