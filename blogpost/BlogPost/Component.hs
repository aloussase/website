module BlogPost.Component
(
    module BlogPost.Internal.Service
  , module BlogPost.Internal.Types
  , Repository
  , newService
  , newRepository
)
where

import           BlogPost.Internal.Repository
import qualified BlogPost.Internal.Repository.InMemory as InMemory
import           BlogPost.Internal.Service
import qualified BlogPost.Internal.Service.Impl        as Service
import           BlogPost.Internal.Types

newService :: IO Service.Handle
newService = pure Service.new

newRepository :: IO InMemory.Handle
newRepository = InMemory.new
