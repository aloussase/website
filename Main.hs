module Main where

import Website.Infrastructure.FileSystemBlogPostRepository
import Website.Application

main :: IO ()
main = newFileSystemRepository >>= run
