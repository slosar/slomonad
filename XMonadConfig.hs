module XMonadConfig
  ( Profile (..),
    profileForHost,
    runXMonad,
  )
where

import Data.Char (toLower)
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import XMonad hiding ((|||))
import XMonad.Actions.CycleWS
  ( nextWS,
    prevWS,
    shiftToNext,
    shiftToPrev,
    toggleWS,
  )
import XMonad.Actions.FindEmptyWorkspace
  ( tagToEmptyWorkspace,
    viewEmptyWorkspace,
  )
import XMonad.Actions.Minimize
  ( maximizeWindowAndFocus,
    minimizeWindow,
    withLastMinimized,
  )
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks
  ( ToggleStruts (ToggleStruts),
    avoidStruts,
    docks,
  )
import XMonad.Layout.BoringWindows (boringWindows)
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.Minimize (minimize)
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.OneBig (OneBig (OneBig))
import XMonad.Layout.ResizableTile
  ( MirrorResize (MirrorExpand, MirrorShrink),
    ResizableTall (ResizableTall),
  )
import XMonad.Layout.ThreeColumns (ThreeCol (ThreeCol))
import XMonad.Prompt
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh (sshPrompt)
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import qualified XMonad.Util.Paste as Paste

data Profile = Lampedusa | Remler
  deriving (Eq, Show)

-- Remler is the safe fallback for the generic entry point. The explicit
-- per-host launchers below do not depend on hostname detection.
profileForHost :: String -> Profile
profileForHost hostname
  | map toLower (takeWhile (/= '.') hostname) == "lampedusa" = Lampedusa
  | otherwise = Remler

runXMonad :: Profile -> IO ()
runXMonad profile =
  xmonad . ewmhFullscreen . ewmh . docks $
    def
      { terminal = terminalCommand,
        focusFollowsMouse = True,
        borderWidth = 1,
        modMask = mod4Mask,
        normalBorderColor = "#555555",
        focusedBorderColor = "#FFFFFF",
        keys = myKeys profile,
        mouseBindings = myMouseBindings,
        manageHook = myManageHook,
        workspaces = map show [1 .. 12 :: Int],
        layoutHook = myLayout
      }

homeDir :: String
homeDir = "/home/anze"

terminalCommand :: String
terminalCommand = homeDir ++ "/local/bin/alaclr.sh"

mailCommand :: String
mailCommand =
  "TMPDIR=" ++ homeDir ++ "/mutmp emacs -q -l " ++ homeDir ++ "/.emacsmail"

imapCommand :: String
imapCommand =
  "rxvt-unicode -bg black -fg gray -e " ++ homeDir ++ "/local/bin/imap"

promptConfig :: XPConfig
promptConfig =
  amberXPConfig
    { position = Bottom,
      promptBorderWidth = 0,
      font = "xft:monospace:size=14",
      height = 50
    }

scratchpads :: [NamedScratchpad]
scratchpads =
  [ NS
      "wcalc"
      "xterm -fa 'Monospace' -fs 14 -e wcalc"
      (title =? "wcalc")
      (customFloating $ W.RationalRect (1 / 6) (1 / 6) (2 / 3) (2 / 3)),
    NS
      "ipython"
      ( "xterm -fa 'Monospace' -fs 14 -xrm 'xterm*allowTitleOps: false'"
          ++ " -T 'iPython' -e " ++ homeDir ++ "/anaconda3/bin/ipython"
      )
      (title =? "iPython")
      (customFloating $ W.RationalRect (4 / 30) (4 / 30) (22 / 30) (22 / 30)),
    NS
      "xterm"
      "xterm -fa 'Monospace' -fs 14 -xrm 'xterm*allowTitleOps: false' -T 'scratch term'"
      (title =? "scratch term")
      (customFloating $ W.RationalRect (3 / 30) (3 / 30) (24 / 30) (24 / 30))
  ]

myKeys :: Profile -> XConfig layout -> M.Map (KeyMask, KeySym) (X ())
myKeys profile conf@(XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    commonBindings
      ++ profileBindings profile modMask
      ++ workspaceBindings conf
      ++ screenBindings modMask
  where
    commonBindings =
      [ ((modMask .|. controlMask, xK_Return), spawn $ terminal conf),
        ((modMask, xK_q), spawn $ terminal conf),
        ((modMask, xK_w), spawn mailCommand),
        ((modMask, xK_i), spawn $ homeDir ++ "/local/bin/cs.py"),
        ((modMask, xK_bracketleft), sendMessage Shrink),
        ((modMask, xK_bracketright), sendMessage Expand),
        ((modMask .|. shiftMask, xK_bracketleft), sendMessage MirrorShrink),
        ((modMask .|. shiftMask, xK_bracketright), sendMessage MirrorExpand),
        ((modMask, xK_l), spawn $ homeDir ++ "/howto/tpad"),
        ((modMask, xK_y), spawn imapCommand),
        ((modMask, xK_o), shellPrompt promptConfig),
        ((modMask .|. shiftMask, xK_o), sshPrompt promptConfig),
        ((modMask, xK_m), spawn "firefox"),
        ((modMask, xK_p), spawn "pavucontrol"),
        ((modMask .|. shiftMask, xK_p), spawn "lxrandr"),
        ((0, xK_Print), Paste.pasteString "_"),
        ((0, xK_Scroll_Lock), Paste.pasteString primaryMeetingUrl),
        ((0, xK_Pause), Paste.pasteString "-"),
        ((modMask, xK_c), kill),
        ((modMask, xK_space), nextWS),
        ((modMask, xK_F1), sendMessage $ JumpToLayout "ResizableTall"),
        ((modMask, xK_F2), sendMessage $ JumpToLayout "Mirror Tall"),
        ((modMask, xK_F3), sendMessage $ JumpToLayout "Full"),
        ((modMask, xK_F4), sendMessage $ JumpToLayout "ThreeCol"),
        ((modMask, xK_F5), sendMessage $ JumpToLayout "C:Big"),
        ((modMask, xK_F11), spawn $ "bash " ++ homeDir ++ "/howto/atwork"),
        ((modMask, xK_F12), spawn $ "bash " ++ homeDir ++ "/howto/workoff"),
        ((mod1Mask, xK_Tab), windows W.focusDown),
        ((modMask, xK_Tab), sendMessage ToggleStruts),
        ((modMask, xK_k), withFocused minimizeWindow),
        ((modMask, xK_j), withLastMinimized maximizeWindowAndFocus),
        ((modMask, xK_a), windows W.focusMaster),
        ((modMask, xK_Return), windows W.swapMaster),
        ((modMask, xK_7), sendMessage Shrink),
        ((modMask, xK_8), sendMessage Expand),
        ((modMask, xK_9), sendMessage MirrorShrink),
        ((modMask, xK_0), sendMessage MirrorExpand),
        ((modMask, xK_t), withFocused $ windows . W.sink),
        ((modMask, xK_comma), sendMessage $ IncMasterN 1),
        ((modMask, xK_period), sendMessage $ IncMasterN (-1)),
        ((modMask, xK_Down), shiftToNext),
        ((modMask, xK_Up), shiftToPrev),
        ((modMask .|. controlMask, xK_Down), windows W.swapDown),
        ((modMask .|. controlMask, xK_Up), windows W.swapUp),
        ((modMask, xK_z), toggleWS),
        ((modMask, xK_s), namedScratchpadAction scratchpads "wcalc"),
        ((modMask, xK_d), namedScratchpadAction scratchpads "ipython"),
        ((modMask, xK_f), namedScratchpadAction scratchpads "xterm")
      ]

profileBindings :: Profile -> KeyMask -> [((KeyMask, KeySym), X ())]
profileBindings Lampedusa modMask =
  [ ((modMask, xK_b), sendMessage Shrink),
    ((modMask, xK_n), sendMessage Expand)
  ]
profileBindings Remler modMask =
  [ ((modMask, xK_b), tagToEmptyWorkspace),
    ((modMask, xK_n), viewEmptyWorkspace),
    ((0, xF86XK_AudioLowerVolume), prevWS),
    ((0, xF86XK_AudioRaiseVolume), nextWS)
  ]

workspaceBindings :: XConfig layout -> [((KeyMask, KeySym), X ())]
workspaceBindings conf =
  [ ((modifier, key), windows $ action workspace)
    | (workspace, key) <- zip (workspaces conf) [xK_F1 .. xK_F12],
      (action, modifier) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]

-- The old comprehension generated each binding twice. Map.fromList silently
-- kept only W.shift, so spell out that effective behavior once.
screenBindings :: KeyMask -> [((KeyMask, KeySym), X ())]
screenBindings modMask =
  [ ( (modMask .|. shiftMask, key),
      screenWorkspace screen >>= flip whenJust (windows . W.shift)
    )
    | (key, screen) <- zip [xK_w, xK_e, xK_r] [0 ..]
  ]

myMouseBindings :: XConfig layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings _ =
  M.fromList
    [ ((mod1Mask, button1), \window -> focus window >> mouseMoveWindow window),
      ((mod1Mask, button2), \window -> focus window >> windows W.swapMaster),
      ((mod1Mask, button3), \window -> focus window >> Flex.mouseResizeWindow window)
    ]

myLayout =
  minimize . boringWindows . avoidStruts . smartBorders $
    ResizableTall 1 (3 / 100) (1 / 2) []
      ||| Mirror (Tall 1 (3 / 100) (1 / 2))
      ||| noBorders Full
      ||| ThreeCol 1 (3 / 100) (1 / 2)
      ||| named "C:Big" (OneBig (3 / 4) (3 / 4))

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Totem" --> doFloat,
      className =? "GV" --> doFloat,
      className =? "Gimp" --> doFloat,
      title =? "Volume Control" --> doFloat,
      title =? "Menu" --> doFloat,
      className =? "Gnubiff" --> doIgnore,
      className =? "Firefox" --> doShift "6",
      className =? "google-chrome" --> doShift "6",
      className =? "Chromium-browser" --> doShift "6",
      title =? "pine" --> doShift "9",
      title =? "Figure 1" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]
    <+> manageZoomHook
    <+> namedScratchpadManageHook scratchpads

manageZoomHook :: ManageHook
manageZoomHook =
  composeAll
    [ (className =? "zoom") <&&> shouldFloat <$> title --> doFloat,
      (className =? "zoom") <&&> shouldTile <$> title --> doTile
    ]
  where
    tiledTitles =
      [ "Zoom - Free Account",
        "Zoom - Licensed Account",
        "Zoom",
        "Zoom Meeting"
      ]
    shouldFloat windowTitle = windowTitle `notElem` tiledTitles
    shouldTile windowTitle = windowTitle `elem` tiledTitles
    doTile = (ask >>= doF . W.sink) <+> doF W.swapDown

primaryMeetingUrl :: String
primaryMeetingUrl =
  "https://bnl.zoomgov.com/j/16021766340?pwd=akoyVTdRVm55YjM0K2tjemZ2YUFZQT09"
