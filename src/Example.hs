module Main where

import Bindings.Objc
import Foreign.Ptr
import Foreign.C.String
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Data.List

main :: IO ()
main = do
    putStrLn "Bindings to the Objective-C Runtime!"

    arbitraryFunctionTest

    classes <- getClassList
    names <- sort <$> mapM getClassName classes

    if "NSHaskell" `elem` names
    then putStrLn "Have access to NSHaskell"
    else putStrLn "Do not have access to NSHaskell"

    if "NSApplication" `elem` names
    then putStrLn "Have access to NSApplication"
    else putStrLn "Do not have access to NSApplication"

getClassList :: IO [CClass]
getClassList = do
    num <- c'objc_getClassList nullPtr 0
    let num' = fromIntegral num
    allocaArray num' $ \ptr -> do
        _ <- c'objc_getClassList ptr num
        peekArray num' ptr

getClassName :: CClass -> IO String
getClassName c = c'class_getName c >>= peekCString

nsHaskellPrint :: CId -> CSEL -> IO CId
nsHaskellPrint cid sel = do
    putStrLn "nsHaskellPrint was called."
    print cid
    return c'Nil

arbitraryFunctionTest :: IO ()
arbitraryFunctionTest = do
    nsObject  <- withCString "NSObject" c'objc_getClass
    nsHaskell <- withCString "NSHaskell" $ \ptr -> c'objc_allocateClassPair nsObject ptr 0
    sel       <- withCString "nshaskellprint" c'sel_getUid
    if (sel == c'nil)
    then putStrLn "Selector is nil."
    else putStrLn "Got selector!"
    nsHP      <- mkImp0 nsHaskellPrint
    added     <- withCString "@@:" $ \ptr -> c'class_addMethod0 nsHaskell sel nsHP ptr

    if (added == c'YES) then do
        c'objc_registerClassPair nsHaskell
        nsh <- c'class_createInstance nsHaskell
        c'objc_msgSend nsh sel
        return ()
    else putStrLn "Could not add method to NSHaskell."


    return ()
