-- Standard code to make a table of symbols.
module Drasil.Sections.TableOfSymbols 
  (table) where

import Data.Drasil.Utils(getS)

import Language.Drasil
import qualified Data.Drasil.Concepts.Math as CM
import Data.Drasil.Concepts.Documentation
 
--Removed SymbolForm Constraint and filtered non-symbol'd chunks 
-- | table of symbols creation function
table :: (Quantity s) => [s] -> (s -> Sentence) -> Contents
table ls f = Table 
  [at_start symbol_, at_start description, at_start' CM.unit_]
  (mkTable
  [(\ch -> (getS ch)),
  f, 
  unit'2Contents]
  ls)
  (titleize tOfSymb) False

-- ^. defn