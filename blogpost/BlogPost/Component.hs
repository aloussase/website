module BlogPost.Component
(
    module BlogPost.Internal.Types
  , BlogPostInfo (..)
  , Component (..)
  , Repository
  , Service (..)
  , new
)
where

import           BlogPost.Internal.Repository
import qualified BlogPost.Internal.Repository.FileSystem as Repository
import           BlogPost.Internal.Service
import qualified BlogPost.Internal.Service.Impl          as Service
import           BlogPost.Internal.Types

data Component =
  Component
  { bpService    :: Service.Handle
  , bpRepository :: Repository.Handle
  }


-- | Create a new BlogPost component.
new :: IO Component
new =  Component Service.new <$> Repository.new
