module Main (main) where

import GHC.IO.Encoding
import Language.Drasil.Generate (gen, genDot, DocSpec(DocSpec), DocType(SRS), Format(..), docChoices)
import Drasil.SSP.Body (srs, printSetting, fullSI)
-- import Drasil.SSP.Choices
       
main :: IO ()            
main = do
  setLocaleEncoding utf8
  gen (DocSpec (docChoices SRS [HTML, TeX]) "SSP_SRS") srs printSetting
  genDot fullSI
  -- for when we can generate code again, uncomment this file and Choices.hs
  --genCode choices code
