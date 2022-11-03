{-# LANGUAGE RankNTypes #-}
module Website.Application.Common where

import           Control.Monad.IO.Class
import           Text.Hamlet

type QueryHandler m query r = (MonadIO m) => query r -> m ()

(!) :: (MonadIO m) => QueryHandler m query repository -> query repository -> m ()
handler ! query = handler query

navbar :: Html
navbar = $(shamletFile "static/templates/Navbar.hamlet")

footer :: Html
footer = $(shamletFile "static/templates/Footer.hamlet")
