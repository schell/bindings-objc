{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}

--------------------------------------------------------------------------------
-- https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html
--------------------------------------------------------------------------------

#include <bindings.dsl.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>

--------------------------------------------------------------------------------

module Bindings.Objc.Types where
#strict_import

import Data.Data (Data,Typeable)
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.Storable

--------------------------------------------------------------------------------
-- Data Structures
-- https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html#//apple_ref/doc/uid/TP40001418-CH3g-116261
--------------------------------------------------------------------------------

#opaque_t struct objc_class
deriving instance Typeable C'objc_class
deriving instance Data     C'objc_class

type CClass = Ptr C'objc_class

#starttype struct objc_object
#field isa, Ptr <objc_class>
#stoptype

type CId = Ptr C'objc_object

type CProtocol = CId

#starttype struct objc_super
#field receiver, CId
#field class, CClass
#stoptype

#opaque_t struct objc_method
deriving instance Typeable C'objc_method
deriving instance Data     C'objc_method

type CMethod = Ptr C'objc_method

#opaque_t objc_ivar
deriving instance Typeable C'objc_ivar
deriving instance Data     C'objc_ivar

type CIvar = Ptr C'objc_ivar

#opaque_t Category
deriving instance Typeable C'Category
deriving instance Data     C'Category

#opaque_t objc_property_t
deriving instance Typeable C'objc_property_t
deriving instance Data     C'objc_property_t

#opaque_t struct objc_selector
deriving instance Typeable C'objc_selector
deriving instance Data     C'objc_selector

type CSEL = Ptr C'objc_selector

#starttype struct objc_method_description
#field name, CSEL
#field types, CString
#stoptype

#starttype struct objc_method_list
#field obsolete, Ptr <objc_method_list>
#field method_count, CInt
#array_field method_list, CMethod
#stoptype

#starttype struct objc_cache
#field mask, CUInt
#field occupied, CUInt
#array_field buckets, CMethod
#stoptype

#starttype struct objc_protocol_list
#field next, Ptr <objc_protocol_list>
#field count, CInt
#array_field list, Ptr CProtocol
#stoptype

#starttype objc_property_attribute_t
#field name, CString
#field value, CString
#stoptype

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

#num YES
#num NO

#pointer nil
#pointer Nil

#num OBJC_OLD_DISPATCH_PROTOTYPES

#num OBJC_ASSOCIATION_ASSIGN
#num OBJC_ASSOCIATION_RETAIN_NONATOMIC
#num OBJC_ASSOCIATION_COPY_NONATOMIC
#num OBJC_ASSOCIATION_RETAIN
#num OBJC_ASSOCIATION_COPY
