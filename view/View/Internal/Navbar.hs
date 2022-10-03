module View.Internal.Navbar
(
  navbar
)
where

import           Text.Hamlet

navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")
