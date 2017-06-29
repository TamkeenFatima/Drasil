{-# Language GADTs #-}

module Drasil.Sections.SolutionCharacterSpec
  (
  SecItem,
  SolSubSec,
  sSubSec,
  scsAssembler,
  siCon,
  siSect,
  siTMod,
  siIMod,
  siDDef,
  siSent,
  siTitl
  ) where

import Language.Drasil
import Data.Drasil.Concepts.Math (equation)
--import Data.Drasil.Concepts.Software (program)
--import Data.Drasil.Utils (foldle)
import Data.Drasil.SentenceStructures
import qualified Data.Drasil.Concepts.Documentation as Doc
import Data.List (find)
import Prelude hiding (id)
import Control.Lens ((^.))

data SecItem where 
  Cont      :: [Contents] -> SecItem
  Sect      :: [Section] -> SecItem
  TMods     :: [RelationConcept] -> SecItem
  IMods     :: [RelationConcept] -> SecItem
  DataDef   :: [QDefinition] -> SecItem
  GenDef    :: [RelationConcept] -> SecItem
  Sent      :: [Sentence] -> SecItem
  TitleFunc :: (CI -> Sentence) -> SecItem

data SolSubSec where
  SectionModel :: CI -> [SecItem] -> SolSubSec


sSubSec :: CI -> [SecItem] -> SolSubSec
sSubSec sectionName xs = SectionModel sectionName xs

siCon :: [Contents] -> SecItem
siCon xs = Cont xs

siSect :: [Section] -> SecItem
siSect xs = Sect xs

siTMod :: [RelationConcept] -> SecItem
siTMod xs = TMods xs

siIMod :: [RelationConcept] -> SecItem
siIMod xs = IMods xs

siDDef :: [QDefinition] -> SecItem
siDDef xs = DataDef xs

siSent :: [Sentence] -> SecItem
siSent xs = Sent xs

siTitl :: (CI -> Sentence) -> SecItem
siTitl f = TitleFunc f

renderSec :: NamedIdea a => a -> SolSubSec -> Section
renderSec progName item@(SectionModel niname _) 
    | compareID niname Doc.assumption     = assumptionSect item
    | compareID niname Doc.thModel        = theoreticalModelSect item progName
    | compareID niname Doc.genDefn        = generalDefinitionSect item
    | compareID niname Doc.inModel        = instanceModelSect item
    | compareID niname Doc.dataDefn       = dataDefinitionSect item
    | compareID niname Doc.dataConst      = dataConstraintSect item
    | otherwise                           = genericSect item


scsAssembler :: (NamedIdea a) => a -> [SolSubSec] -> Section
scsAssembler progName subsecs = section (titleize' Doc.solutionCharSpec) 
  [scsIntro progName] subsections
  where subsections = map (renderSec progName) subsecs 
  --FIXME put in correct order, if out of order for subsections

scsIntro :: (NamedIdea a) => a -> Contents
scsIntro progName = foldlSP [S "The", plural Doc.inModel, 
  S "that govern", short progName, S "are presented in" +:+. 
  S "FIXME REF to IModSection", S "The", phrase Doc.information, S "to understand", 
  (S "meaning" `ofThe` plural Doc.inModel), 
  S "and their derivation is also presented, so that the", plural Doc.inModel, 
  S "can be verified"]


----------------------
--  HELPER FUNCTION --
----------------------

compareID ::  CI -> CI -> Bool
compareID c1 c2 = (c1 ^. id) == (c2 ^. id)

hasTitle :: SecItem -> Bool
hasTitle (TitleFunc _) = True
hasTitle _             = False

hasCont :: SecItem -> Bool
hasCont (Cont _) = True
hasCont _        = False

hasSect :: SecItem -> Bool
hasSect (Sect _) = True
hasSect _        = False

hasSent :: SecItem -> Bool
hasSent (Sent _) = True
hasSent _        = False

getSecItem :: (a->Bool) -> [a] -> Maybe a
getSecItem func ls = find (func) ls

getTitleize :: (Maybe SecItem) -> (CI -> Sentence)
getTitleize (Just (TitleFunc a)) = a
getTitleize (Just _) = titleize
getTitleize Nothing = titleize

getSection :: (Maybe SecItem) -> [Section]
getSection (Just (Sect xs)) = xs
getSection (Just _) = []
getSection Nothing = []

getSecContents :: (Maybe SecItem) -> [Contents]
getSecContents (Just (Cont xs)) = xs
getSecContents (Just _) = []
getSecContents Nothing = []

getSent :: (Maybe SecItem) -> [Sentence]
getSent (Just (Sent xs)) = xs
getSent (Just _)         = []
getSent Nothing          = []

pullFunc :: [SecItem] -> (Maybe SecItem -> t) -> (SecItem -> Bool) -> t
pullFunc xs f g = f (getSecItem g xs)

pullTitle :: [SecItem] -> CI -> Sentence
pullTitle xs = pullFunc xs getTitleize hasTitle

pullSections :: [SecItem] -> [Section]
pullSections xs = pullFunc xs getSection hasSect

pullContents :: [SecItem] -> [Contents]
pullContents xs = pullFunc xs getSecContents hasCont

pullSents :: [SecItem] -> [Sentence]
pullSents xs = pullFunc xs getSent hasSent

------------------------------
-- Section Render Functions --
------------------------------

genericSect :: SolSubSec -> Section
genericSect (SectionModel niname xs) = section ((pullTitle xs) niname) (pullContents xs)
  (pullSections xs)

assumptionSect :: SolSubSec -> Section
assumptionSect (SectionModel niname xs) = section (titleize' niname)
  (assumpIntro:(pullContents xs)) (pullSections xs)

theoreticalModelSect :: (NamedIdea a) => SolSubSec -> a -> Section
theoreticalModelSect (SectionModel niname xs) progName = section (titleize' niname) 
  ((tModIntro progName):(pullContents xs)) (pullSections xs)

--FIXME geenrate tables here
--s4_2_2_TMods = map cpSymMapT cpTMods

generalDefinitionSect :: SolSubSec -> Section
generalDefinitionSect (SectionModel niname xs) = section (titleize' niname)
  ((generalDefinitionIntro contents):contents) (pullSections xs)
  where contents = (pullContents xs)

instanceModelSect :: SolSubSec -> Section
instanceModelSect (SectionModel niname xs) = section (titleize' niname)
  ((iModIntro):(pullContents xs)) (pullSections xs)

--FIXME generate tables here
--s4_2_5_IMods = map cpSymMapT iModels

dataDefinitionSect :: SolSubSec -> Section
dataDefinitionSect (SectionModel niname xs) = section (titleize' niname)
  ((dataDefinitionIntro $ pullSents xs):(pullContents xs)) (pullSections xs)

--FIXME generate tables here
--s4_2_4_DDefs = map cpSymMapD cpDDefs

dataConstraintSect :: SolSubSec -> Section
dataConstraintSect (SectionModel niname xs) = section (titleize' niname)
  ((dataConIntro ):(pullContents xs)) (pullSections xs)
  where dataConIntro = dataConstraintParagraph (pullContents xs) (pullSents xs)

--FIXME generate tables here
--



-- takes a bunch of references to things discribed in the wrapper
assumpIntro :: Contents
assumpIntro = Paragraph $ foldlSent 
  [S "This", (phrase Doc.section_), S "simplifies the original", (phrase Doc.problem), 
  S "and helps in developing the", (phrase Doc.thModel), S "by filling in the", 
  S "missing", (phrase Doc.information), S "for the" +:+. (phrase Doc.physicalSystem), 
  S "The numbers given in the square brackets refer to the", 
  foldr1 sC (map (refs) (itemsAndRefs)) `sC` S "or", 
  refs (Doc.likelyChg) `sC` S "in which the respective", 
  (phrase Doc.assumption), S "is used"] --FIXME: use some clever "zipWith"
  where refs chunk = (titleize' chunk) {--+:+ sSqBr (makeRef ref)--} 
        itemsAndRefs = [Doc.thModel, Doc.genDefn, Doc.dataDefn, Doc.inModel] --FIXME ADD REFS BACK


tModIntro :: (NamedIdea a) => a -> Contents
tModIntro progName = foldlSP [S "This", phrase Doc.section_, S "focuses on",
  S "the", phrase Doc.general, (plural equation), S "and", S "laws that",
  short progName, S "is based on"]


generalDefinitionIntro :: (LayoutObj t) => [t] -> Contents
generalDefinitionIntro [] = Paragraph $ S "There are no general definitions."
generalDefinitionIntro _ = foldlSP [S "This", phrase Doc.section_, 
  S "collects the", S "laws and", (plural equation), 
  S "that will be used in", S "deriving the", 
  plural Doc.dataDefn `sC` S "which in turn are used to", S "build the", 
  plural Doc.inModel]


dataDefinitionIntro :: [Sentence] -> Contents
dataDefinitionIntro xs = Paragraph $ (foldlSent [S "This", phrase Doc.section_, 
    S "collects and defines all the", plural Doc.datum, 
    S "needed to build the", plural Doc.inModel] +:+ foldl (+:+) EmptyS xs)


-- just need to provide the four references in order to this function. Nothing can be input into r4 if only three tables are present
iModIntro :: Contents
iModIntro = foldlSP [S "This", phrase Doc.section_, 
  S "transforms the", phrase Doc.problem, S "defined in", S "FIXME REF", 
  S "into one which is expressed in mathematical terms. It uses concrete", 
  plural Doc.symbol_, S "defined in", S "FIXME REF", 
  S "to replace the abstract", plural Doc.symbol_, S "in the", 
  plural Doc.model, S "identified in", S "FIXME REF" :+: S " and" +:+ S "FIXME REF"]


-- makes a list of references to tables takes
-- l  list of layout objects that can be referenced
-- outputs a sentence containing references to the layout objects 
listofTablesToRefs :: LayoutObj l => [l] -> Sentence
listofTablesToRefs  []     = EmptyS
listofTablesToRefs  [x]    = (makeRef x) +:+ S "shows"
listofTablesToRefs  [x,y]  = (makeRef x) `sC` S "and" +:+ listofTablesToRefs [y]
listofTablesToRefs  (x:xs) = (makeRef x) `sC` listofTablesToRefs (xs)

-- reference to the input/ ouput tables -> optional middle sentence(s) (use EmptyS if not wanted) -> 
-- True if standard ending sentence wanted -> optional trailing sentence(s) -> Contents
dataConstraintParagraph :: [Contents] -> [Sentence] -> Contents
dataConstraintParagraph tableRef [] = Paragraph $ 
  (dataConstraintIntroSent tableRef) +:+ (dataConstraintClosingSent [EmptyS])
dataConstraintParagraph tableRef (mid:xs) = Paragraph $
  (dataConstraintIntroSent tableRef) +:+ mid +:+ 
  (dataConstraintClosingSent xs)

dataConstraintIntroSent :: [Contents] -> Sentence
dataConstraintIntroSent tableRef = foldlSent [(listofTablesToRefs tableRef), S "the", 
  plural Doc.datumConstraint, S "on the", phrase Doc.input_, 
  S "and", phrase Doc.output_ +:+. (plural Doc.variable `sC` S "respectively"), S "The", 
  phrase Doc.column, S "for", phrase Doc.physical, plural Doc.constraint, S "gives the", 
  phrase Doc.physical, plural Doc.limitation, S "on the range of", plural Doc.value, 
  S "that can be taken by the", phrase Doc.variable]

dataConstraintClosingSent :: [Sentence] -> Sentence
dataConstraintClosingSent trailing = (foldlSent
  [S "The", plural Doc.constraint, S "are conservative, to give", 
  (phrase Doc.user `ofThe` phrase Doc.model), S "the flexibility to", 
  S "experiment with unusual situations. The", phrase Doc.column, S "of", S "typical",
  plural Doc.value, S "is intended to provide a feel for a common scenario"])
  +:+ dataConstraintUncertainty +:+ S "FIXME" +:+ (foldl (+:+) EmptyS trailing) 
  --FIXME make uncertainty specificiable 

dataConstraintUncertainty :: Sentence
dataConstraintUncertainty = foldlSent [S "The", phrase Doc.uncertainty, phrase Doc.column,
  S "provides an", S "estimate of the confidence with which the", phrase Doc.physical,
  plural Doc.quantity +:+. S "can be measured", S "This", phrase Doc.information,
  S "would be part of the", phrase Doc.input_, S "if one were performing an",
  phrase Doc.uncertainty, S "quantification exercise"]
