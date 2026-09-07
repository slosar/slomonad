import System.Posix.Unistd (SystemID (nodeName), getSystemID)
import XMonadConfig (profileForHost, runXMonad)

main :: IO ()
main = getSystemID >>= runXMonad . profileForHost . nodeName
