module BlogPost.Component
(
    module BlogPost.Internal.Types
  , Component (..)
  , Repository
  , Service (..)
  , new
)
where

import           BlogPost.Internal.Repository
import qualified BlogPost.Internal.Repository.InMemory as InMemory
import           BlogPost.Internal.Service
import qualified BlogPost.Internal.Service.Impl        as Service
import           BlogPost.Internal.Types

data Component =
  Component
  { bpService    :: Service.Handle
  , bpRepository :: InMemory.Handle
  }


-- | Create a new BlogPost component.
new :: IO Component
new = Component <$> pure Service.new <*> InMemory.new
