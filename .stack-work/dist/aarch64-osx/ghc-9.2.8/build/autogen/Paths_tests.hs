{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_tests (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,1] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/bin"
libdir     = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/lib/aarch64-osx-ghc-9.2.8/tests-0.0.1-409rslOM85jJdNvoEvwqzu"
dynlibdir  = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/lib/aarch64-osx-ghc-9.2.8"
datadir    = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/share/aarch64-osx-ghc-9.2.8/tests-0.0.1"
libexecdir = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/libexec/aarch64-osx-ghc-9.2.8/tests-0.0.1"
sysconfdir = "/Users/rohitkumar/Desktop/haskell/assignment/haskell-mooc/exercises/.stack-work/install/aarch64-osx/4ae0c64b24a3fa0d747177cd697b891ff5460bbb007eea8d997c45b534e38d1c/9.2.8/etc"

getBinDir     = catchIO (getEnv "tests_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "tests_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "tests_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "tests_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "tests_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "tests_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
