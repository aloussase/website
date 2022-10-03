module Main where

import qualified BlogPost.Component as BlogPost
import           Web.Component      (runWebApp)

main :: IO ()
main = do
  blogPostService <- BlogPost.newService
  blogPostRepository <- BlogPost.newRepository
  runWebApp blogPostService blogPostRepository
