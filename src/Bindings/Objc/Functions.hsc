--------------------------------------------------------------------------------
-- https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html
--------------------------------------------------------------------------------

#include <bindings.dsl.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>

--------------------------------------------------------------------------------

module Bindings.Objc.Functions where
#strict_import

import Bindings.Objc.Types
import Data.Data (Data,Typeable)
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.Storable

--------------------------------------------------------------------------------
-- Working with Classes
--------------------------------------------------------------------------------

#ccall class_getName             , CClass -> IO CString
#ccall class_getSuperclass       , CClass -> IO CClass
#ccall class_isMetaClass         , CClass -> IO CUInt
#ccall class_getInstanceSize     , CClass -> IO CSize
#ccall class_getInstanceVariable , CClass -> CString -> IO CIvar
#ccall class_copyMethodList      , CClass -> Ptr CInt -> IO (Ptr CMethod)

type Imp0 = CId -> CSEL -> IO CId

foreign import ccall safe "static class_addMethod" c'class_addMethod0 :: CClass -> CSEL -> FunPtr Imp0 -> CString -> IO CInt
foreign import ccall "wrapper" mkImp0 :: Imp0 -> IO (FunPtr Imp0)

--------------------------------------------------------------------------------
-- Adding Classes
--------------------------------------------------------------------------------

#ccall objc_allocateClassPair , CClass -> CString -> CSize -> IO CClass
#ccall objc_registerClassPair , CClass -> IO ()

--------------------------------------------------------------------------------
-- Instantiating Classes
--------------------------------------------------------------------------------

#ccall class_createInstance , CClass -> IO CId

--------------------------------------------------------------------------------
-- Working with Instances
--------------------------------------------------------------------------------

#ccall object_getClass     , CId -> IO CClass
#ccall object_getClassName , CId -> IO CString

--------------------------------------------------------------------------------
-- Obtaining Class Definitions
--------------------------------------------------------------------------------

#ccall objc_getClassList , Ptr CClass -> CInt -> IO CInt
#ccall objc_getClass     , CString    -> IO CClass

--------------------------------------------------------------------------------
-- Working with Selectors
--------------------------------------------------------------------------------

#ccall sel_getName      , CSEL -> IO CString
#ccall sel_registerName , CString -> IO CSEL
#ccall sel_getUid       , CString -> IO CSEL
#ccall sel_isEqual      , CSEL -> CSEL -> IO CInt

--------------------------------------------------------------------------------
-- Sending Messages
--------------------------------------------------------------------------------

#ccall objc_msgSend , CId -> CSEL -> IO CId

--------------------------------------------------------------------------------
-- Working with Methods
--------------------------------------------------------------------------------

#ccall method_getName , CMethod -> IO CSEL
