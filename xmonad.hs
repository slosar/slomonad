--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
 
import XMonad hiding ( (|||) ) -- don't use the normal ||| operator
import XMonad.Config.Gnome
import System.Exit
 

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Actions.CycleWS
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.OneBig
import XMonad.Layout.Minimize
import XMonad.Layout.BoringWindows
import XMonad.Layout.Named (named)
import XMonad.Actions.Minimize

import XMonad.Util.Scratchpad
import XMonad.Util.Run   -- for spawnPipe and h
import Data.Ratio
import XMonad.Actions.FindEmptyWorkspace

import XMonad.Layout.ResizableTile
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Layout.Grid
import XMonad.Layout.CenteredMaster

import XMonad.Prompt
import XMonad.Prompt.Shell

--import DBus.Client.Simple
--import System.Taffybar.XMonadLog ( dbusLogWithPP )
--import Web.Encodings ( decodeHtml, encodeHtml )

import XMonad.Hooks.EwmhDesktops



 
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminalSmall      = "rxvt-unicode -tn xterm -uc -bc -st -sr -si -sk -T null -title null -bg \\#`randcolor.py` -fg \\#EEEEEE -fn xft:Mono:pixelsize=12"
myTerminalLarge      = "rxvt-unicode -tn xterm -uc -bc -st -sr -si -sk -T null -title null -bg \\#`randcolor.py` -fg \\#EEEEEE -fn xft:Mono:pixelsize=18"
--myTerminalpine       = "rxvt-unicode -tn xterm +sb -bc -cr orange -st -sr -si -sk -T null -title pine -bg black -fg \\#DDDDDD -fn xft:Ubuntu\\ Mono:pixelsize=24 -e pine"
myTerminalpine       = "emacs -q -l /home/anze/.emacsmail"
myIMAP      = "rxvt-unicode -bg black -fg gray -e /home/anze/local/bin/imap"
myTerminalbach      = "/home/anze/local/bin/astro_term"
myTerminalhopper      = "rxvt-unicode -tn xterm -uc -bc -st -sr -si -sk -T null -title astro -bg \\#`randcolor.py` -fg \\#DDDDDD -fn xft:Mono:pixelsize=16 -e ssh cori"
myTerminalKosovel      = "rxvt-unicode -tn xterm -uc -bc -st -sr -si -sk -T null -title kos -bg \\#`randcolor.py` -fg \\#DDDDDD -fn xft:Mono:pixelsize=14 -e ssh kos"

-- Width of the window border in pixels.
--

myBorderWidth   = 1
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask 
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--               
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10","11","12"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#555555"
myFocusedBorderColor = "#FFFFFF"
 
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- launch a terminal
    [ ((modMask .|. controlMask, xK_Return), spawn $ XMonad.terminal conf),
 
      ((modMask, xK_q), spawn $ XMonad.terminal conf),
      ((modMask, xK_w), spawn myTerminalpine) ,
      ((modMask, xK_e), spawn myTerminalhopper) ,
      ((modMask, xK_a), spawn myTerminalKosovel) ,
      ((modMask,               xK_v   ), spawn "/home/anze/local/bin/middlebutton"),	
      ((modMask,               xK_Left   ), spawn "amixer set Master 1%-"),	
      ((modMask,               xK_Right   ), spawn "amixer set Master 1%+"),	
      ((modMask,               xK_i   ), spawn "bash -c /home/anze/local/bin/cs.py"),	
      ((modMask.|. controlMask,               xK_bracketleft   ), spawn "xbacklight -inc -10"),	
      ((modMask.|. controlMask,               xK_bracketright   ), spawn "xbacklight -inc +10"),	
      ((modMask,                xK_bracketleft     ), sendMessage Shrink),
      ((modMask,               xK_bracketright     ), sendMessage Expand),
      ((modMask .|. shiftMask,               xK_bracketleft     ), sendMessage MirrorShrink),
      ((modMask .|. shiftMask,               xK_bracketright     ), sendMessage MirrorExpand),

      ((modMask, xK_l     ), spawn "/home/anze/howto/tpad") ,


      ((modMask, xK_y), spawn myIMAP) ,
      ((modMask, xK_o), shellPrompt defaultXPConfig)
 
    , ((modMask, xK_m), spawn "google-chrome-stable")
    , ((modMask, xK_p), spawn "pavucontrol")
    , ((modMask .|. shiftMask, xK_p), spawn "lxrandr")


    -- close focused window 
    , ((modMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), nextWS)

    --  Set layout 1.
    , ((modMask , xK_F1 ), sendMessage $ JumpToLayout "ResizableTall" )
    , ((modMask , xK_F2 ), sendMessage $ JumpToLayout "Mirror Tall" )
    , ((modMask , xK_F3 ), sendMessage $ JumpToLayout "Full" )
    , ((modMask , xK_F4 ), sendMessage $ JumpToLayout "ThreeCol" )
    , ((modMask , xK_F5 ), sendMessage $ JumpToLayout "C:Big" )

    , ((modMask , xK_F11 ), spawn "bash /home/anze/howto/atwork" )
    , ((modMask , xK_F12 ), spawn "bash /home/anze/howto/workoff" )



    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((mod1Mask,               xK_Tab   ), windows W.focusDown)

    , ((modMask,               xK_Tab   ), sendMessage ToggleStruts)
 
 
    -- Move focus to the previous window
    , ((modMask,               xK_k     ),  withFocused minimizeWindow  )
    , ((modMask,               xK_j     ), withLastMinimized maximizeWindowAndFocus )


    -- Move focus to the master window
    , ((modMask,               xK_a     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)
  
    -- Shrink the master area
    , ((modMask,               xK_7     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modMask,               xK_8     ), sendMessage Expand)

    -- MirrorShrink the master area
    , ((modMask,              xK_9     ), sendMessage MirrorShrink)
 
    -- MirroExpand the master area
    , ((modMask,              xK_0     ), sendMessage MirrorExpand)

 
    -- push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

--    , ((modMask,               xK_g     ), sendMessage $ ToggleGaps) 
--    , ((modMask,               xK_h     ), sendMessage $ IncGap 50 D)
--    , ((modMask .|. controlMask, xK_h     ), sendMessage $ DecGap 50 D)



    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))
 
   , ((modMask, xK_Down),  shiftToNext)
   , ((modMask, xK_Up),    shiftToPrev)
   , ((modMask .|. controlMask, xK_Down     ), windows W.swapDown  )
   , ((modMask .|. controlMask, xK_Up     ), windows W.swapUp    )


   , ((modMask, xK_z),     toggleWS)
   , ((modMask, xK_s),  scratchpadSpawnAction conf)
 
   , ((modMask,                xK_n    ), viewEmptyWorkspace)
   , ((modMask,                xK_b    ), tagToEmptyWorkspace)

 
    -- Restart xmonad
    , ((modMask .|. controlMask             , xK_q     ),
          broadcastMessage ReleaseResources >> restart "/home/anze/.cabal/bin/xmonad" True)


    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m , k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F12]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask .|. shiftMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((mod1Mask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((mod1Mask, button2), (\w -> focus w >> windows W.swapMaster))
                          
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((mod1Mask , button3), (\w -> focus w >> Flex.mouseResizeWindow w))	

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled  ||| Mirror tiled ||| Full ||| Grid ||| Circle ||| mosaic 0.25 0.5
--  where
--     -- default tiling algorithm partitions the screen into two panes
--     tiled = ResizableTall 1 (3/100) (1/2) []
--     tiled   = ResizableTall nmaster delta ratio
 
     -- The default number of windows in the master pane
--     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
--     ratio   = 2/3
 
     -- Percent of screen to increment by when resizing panes
--     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Totem"          --> doFloat
    , className =? "GV"             --> doFloat
    , className =? "Gimp"           --> doFloat
    , title =? "Volume Control"     --> doFloat
    , title =? "Menu"       --> doFloat
    , className =? "Gnubiff"        --> doIgnore
    , className =? "Firefox"        --> doShift "6"
    , className =? "google-chrome"        --> doShift "6"
    , className =? "Chromium-browser"        --> doShift "6"
    , title =? "pine"        	    --> doShift "9"	       
    , title =? "Figure 1"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore]
    <+> manageDocks <+> scratchpadManageHookDefault
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

	    
myLogHook :: X ()
myLogHook = do ewmhDesktopsLogHook 
               return()


 
------------------------------------------------------------------------


main = do
    xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminalLarge,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts

        manageHook       =  myManageHook,
        workspaces       = map show [1 .. 12 :: Int],
        --logHook          =  dbusLogWithPP client pp,
	logHook = myLogHook,
        handleEventHook = docksEventHook <+> fullscreenEventHook <+> ewmhDesktopsEventHook <+> handleEventHook defaultConfig ,
--        layoutHook       =  avoidStruts $ smartBorders (gaps [(D,10)] $ ResizableTall 1 (3/100) (1/2) []  ||| Mirror tall ||| noBorders Full ||| ThreeCol 1 (3/100) (1/2) ||| centerMaster Grid )
        layoutHook       =  minimize $ boringWindows $ avoidStruts $ smartBorders (ResizableTall 1 (3/100) (1/2) []  ||| Mirror tall ||| noBorders Full ||| ThreeCol 1 (3/100) (1/2) ||| named "C:Big" (OneBig (3/4) (3/4) ) )
} where tall = Tall 1 (3/100) (1/2)


