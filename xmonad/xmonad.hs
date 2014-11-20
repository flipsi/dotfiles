import XMonad

main :: IO ()
main = xmonad defaultConfig
	{ modMask = mod4Mask -- use super instead of alt
	, terminal = "gnome-terminal"
	}
