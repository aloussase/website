module View.Internal.Static
(
  renderCss
)
where

import           Data.Text.Lazy (Text)
import qualified Text.Cassius   as C

-- dummy render function, not used
render = undefined

renderCss :: Text
#if PRODUCTION
renderCss = C.renderCss $ $(C.cassiusFile "static/templates/Styles.cassius") render
#else
renderCss = C.renderCss $ $(C.cassiusFileReload "static/templates/Styles.cassius") render
#endif
