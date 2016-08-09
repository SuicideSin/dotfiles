import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run

import System.Directory
import Text.Printf
import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do
    home <- getHomeDirectory
    xmonad =<< statusBar "xmobar" barConfig toggleStrutsKey desktopConfig
        { terminal           = "st dvtm -M"
        , focusedBorderColor = "#666666"
        , normalBorderColor  = "black"
        , borderWidth        = 2
        , handleEventHook    = mconcat [docksEventHook, handleEventHook def]
        , keys               = myKeys home
        }

barConfig :: PP
barConfig = xmobarPP
    { ppCurrent         = xmobarColor white   black  . wrap " " " "
    , ppHiddenNoWindows = xmobarColor light   dark   . wrap " " " "
    , ppHidden          = xmobarColor light   dark   . wrap "◦" " "
    , ppUrgent          = xmobarColor black   red
    , ppWsSep           = ""
    , ppSep             = " ░ "
    }
  where
    red   = "red"
    white = "white"
    black = "black"
    light = "#888888"
    dark  = "#333333"

toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myKeys :: FilePath -> XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeys home conf@XConfig { XMonad.modMask = modMask } =
    Map.union (XMonad.keys def conf) ks
  where
    ks = Map.fromList
       [ ((modMask, xK_F12),     safeSpawn "systemctl" ["suspend"])
       , ((noModMask, xK_Print), spawn $ printf "scrot -u -e 'mv $f %s/screenshots'" home)
       ]