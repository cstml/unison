module Unison.CodebasePath
  ( CodebasePath,
    getCodebaseDir,
  )
where

import Control.Monad.IO.Class (MonadIO)
import UnliftIO.Directory (getHomeDirectory)

type CodebasePath = FilePath

getCodebaseDir :: MonadIO m => Maybe CodebasePath -> m CodebasePath
getCodebaseDir = maybe getHomeDirectory pure
