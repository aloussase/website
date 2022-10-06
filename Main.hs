module Main where

import qualified BlogPost.Component as BPC
import           Web.Component      (runWebApp)

main :: IO ()
main = do
  bpComponent <- BPC.new
  runWebApp bpComponent
