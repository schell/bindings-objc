{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
module Bindings.Objc.TH where

import Language.Haskell.TH
import Bindings.Objc.Types

mkMsgSend :: String -> [Name] -> Q [Dec]
mkMsgSend s ts = do
    let cf  = "static objc/objc.h objc_msgSend"
        n   = mkName s
        io  = appT (conT ''IO) (conT ''CId)
        ts' = map conT $ ''CId : ''CSEL : ts
    ty <- foldr appapparrow io ts'
    return [ForeignD $ ImportF CCall Safe cf n ty]

appapparrow :: TypeQ -> TypeQ -> TypeQ
appapparrow a b = appT (appT arrowT a) b

