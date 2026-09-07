## Slosar's XMonad config

After ten years, time to commit this.

The shared configuration lives in `XMonadConfig.hs`. The small
`xmonad-<host>.hs` files select a machine profile explicitly. The generic
`xmonad.hs` chooses the Lampedusa profile on `lampedusa` and the Remler profile
everywhere else.

To install a profile, copy the shared module and the appropriate entry point:

```sh
cp XMonadConfig.hs ~/.xmonad/
cp xmonad-remler.hs ~/.xmonad/xmonad.hs
xmonad --recompile
```
