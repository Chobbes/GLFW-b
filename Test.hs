import qualified Test.Framework                 as TF
import qualified Test.Framework.Providers.HUnit as TF
import qualified Test.HUnit                     as HU

import qualified Graphics.UI.GLFW as GLFW

import Data.List (intercalate, isPrefixOf)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

main :: IO ()
main = do
    r <- GLFW.initialize
    TF.defaultMain tests
    GLFW.terminate

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

versionMajor, versionMinor, versionRevision :: Int
versionMajor    = 3
versionMinor    = 0
versionRevision = 0

glfwVersion :: GLFW.Version
glfwVersion = GLFW.Version versionMajor versionMinor versionRevision

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

tests :: [TF.Test]
tests =
    [ TF.testGroup "main"
        [ TF.testCase "getVersion"             test_getVersion
        , TF.testCase "getVersionString"       test_getVersionString
        , TF.testCase "getMonitors"            test_getMonitors
        , TF.testCase "getPrimaryMonitor"      test_getPrimaryMonitor
        , TF.testCase "getMonitorPosition"     test_getMonitorPosition
        , TF.testCase "getMonitorPhysicalSize" test_getMonitorPhysicalSize
        , TF.testCase "getMonitorName"         test_getMonitorName
        , TF.testCase "getVideoModes"          test_getVideoModes
        , TF.testCase "getVideoMode"           test_getVideoMode
        -- , TF.testCase "setGamma"               test_setGamma
        -- , TF.testCase "defaultWindowHints"     test_defaultWindowHints
        ]
    ]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

test_getVersion :: IO ()
test_getVersion = do
    v <- GLFW.getVersion
    HU.assertBool "(==)" $
        v == glfwVersion
    HU.assertBool "values" $
        GLFW.versionMajor    v == versionMajor    &&
        GLFW.versionMinor    v == versionMinor    &&
        GLFW.versionRevision v == versionRevision

test_getVersionString :: IO ()
test_getVersionString = do
    vs <- GLFW.getVersionString
    HU.assertBool "version" $
        let ver = intercalate "." $ map show [versionMajor, versionMinor, versionRevision]
        in ver `isPrefixOf` vs

test_getMonitors :: IO ()
test_getMonitors = do
    r <- GLFW.getMonitors
    case r of
      (Just ms) -> HU.assertBool "empty" $ (not . null) ms
      Nothing   -> HU.assertFailure "error"

test_getPrimaryMonitor :: IO ()
test_getPrimaryMonitor = do
    r <- GLFW.getPrimaryMonitor
    case r of
      (Just _) -> return ()
      Nothing  -> HU.assertFailure "error"

test_getMonitorPosition :: IO ()
test_getMonitorPosition = do
    (Just m) <- GLFW.getPrimaryMonitor
    (x, y) <- GLFW.getMonitorPosition m
    HU.assertBool "invalid x" $ x >= 0
    HU.assertBool "invalid y" $ y >= 0

test_getMonitorPhysicalSize :: IO ()
test_getMonitorPhysicalSize = do
    (Just m) <- GLFW.getPrimaryMonitor
    (w, h) <- GLFW.getMonitorPhysicalSize m
    HU.assertBool "invalid width"  $ w >= 0
    HU.assertBool "invalid height" $ h >= 0

test_getMonitorName :: IO ()
test_getMonitorName = do
    (Just m) <- GLFW.getPrimaryMonitor
    r <- GLFW.getMonitorName m
    case r of
      (Just _) -> return ()
      Nothing  -> HU.assertFailure "error"

test_getVideoModes :: IO ()
test_getVideoModes = do
    (Just m) <- GLFW.getPrimaryMonitor
    r <- GLFW.getVideoModes m
    case r of
      (Just _) -> return ()  -- XXX do more strict checking here
      Nothing  -> HU.assertFailure "error"

test_getVideoMode :: IO ()
test_getVideoMode = do
    (Just m) <- GLFW.getPrimaryMonitor
    r <- GLFW.getVideoMode m
    case r of
      (Just _) -> return ()  -- XXX do more strict checking here
      Nothing  -> HU.assertFailure "error"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

{-# ANN module "HLint: ignore Use camelCase" #-}