module BlogPost.Internal.Service.Impl
(
    Handle
  , new
)
where

import qualified BlogPost.Internal.Repository as R
import           BlogPost.Internal.Service

import           Control.Monad.IO.Class       (liftIO)

data Handle = Handle

instance Service Handle where
  findAll _ r = liftIO $ R.findAll r

  findById _ r id = liftIO $ R.findById r id


new :: Handle
new = Handle

