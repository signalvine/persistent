{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE QuasiQuotes, TemplateHaskell, CPP, GADTs, TypeFamilies, OverloadedStrings, FlexibleContexts, EmptyDataDecls  #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module MigrationColumnLengthTest where

#if defined(WITH_POSTGRESQL) || defined(WITH_MYSQL)

import Database.Persist.TH
import qualified Data.Text as T

import Init

share [mkPersist sqlSettings, mkMigrate "migration"] [persistLowerCase|
VaryingLengths
    field1 Int
    field2 T.Text sqltype=varchar(5)
|]

specs :: Spec
specs = describe "Migration" $ do
    it "is idempotent" $ db $ do
      again <- getMigration migration
      liftIO $ again @?= []
#endif
