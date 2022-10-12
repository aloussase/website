module Main where

import qualified BlogPost.Component as BPC
import qualified Web.Component      as Web

main :: IO ()
main = BPC.newFileSystemRepository >>= Web.run
