{-# LANGUAGE Rank2Types #-}
-- Standard code to make a table of symbols.
module Drasil.TableOfSymbols(table_of_symbols,table, defaultF, cdefnF) where

import Control.Lens ((^.))

import Language.Drasil

table_of_symbols :: (Unit' s) => [s] -> (s -> Sentence) -> Section
table_of_symbols ls f = Section (S "Table of Symbols") 
  [Con intro, Con (table ls f)]

intro :: Contents
intro = Paragraph $ 
  S "The table that follows summarizes the symbols used in this " :+:
  S "document along with their units.  The choice of symbols was " :+:
  S "made with the goal of being consistent with the nuclear " :+:
  S "physics literature and that used in the FP manual.  The SI " :+:
  S "units are listed in brackets following the definition of " :+:
  S "the symbol."
  
table :: (Unit' s) => [s] -> (s -> Sentence) -> Contents
table ls f = Table [S "Symbol", S "Description", S "Units"] (mkTable
  [(\ch -> P (ch ^. symbol)) , 
   (\ch -> f ch), 
   unit'2Contents]
  ls)
  (S "Table of Symbols") False
  
defaultF :: (Unit' s) => s -> Sentence
defaultF = \s -> s ^. descr

cdefnF :: (Unit' s, ConceptDefinition' s) => s -> Sentence
cdefnF = \s -> unWrap s (s ^. cdefn')
  where unWrap _ (Just s) = s
        unWrap c (Nothing) = c ^. descr