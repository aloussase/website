module Web.Internal.View.Navbar where

import           Text.Hamlet


navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")
