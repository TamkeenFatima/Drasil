{-# LANGUAGE TupleSections #-}
module Drasil.Projectile.Choices where

import Language.Drasil (Space(..), abrv)
import Language.Drasil.Code (Choices(..), Comments(..), 
  Verbosity(..), ConstraintBehaviour(..), ImplementationType(..), Lang(..), 
  Logging(..), Modularity(..), Structure(..), ConstantStructure(..), 
  ConstantRepr(..), InputModule(..), CodeConcept(..), matchConcepts, SpaceMatch,
  matchSpaces, AuxFile(..), Visibility(..), defaultChoices, codeSpec, makeArchit, 
  Architecture(..), makeData, DataInfo(..), Maps(..), makeMaps, spaceToCodeType,
  makeConstraints, makeDocConfig, makeLogConfig, LogConfig(..))
import Language.Drasil.Generate (genCode)
import GOOL.Drasil (CodeType(..))
import Data.Drasil.Quantities.Math (piConst)
import Drasil.Projectile.Body (fullSI)
import SysInfo.Drasil (SystemInformation(SI, _sys))

import Data.List (intercalate)
import System.Directory (createDirectoryIfMissing, getCurrentDirectory, 
  setCurrentDirectory)
import Data.Char (toLower)

genCodeWithChoices :: [Choices] -> IO ()
genCodeWithChoices [] = return ()
genCodeWithChoices (c:cs) = let dir = map toLower $ codedDirName (getSysName fullSI) c
                                getSysName SI{_sys = sysName} = abrv sysName
  in do
    workingDir <- getCurrentDirectory
    createDirectoryIfMissing False dir
    setCurrentDirectory dir
    genCode c (codeSpec fullSI c [])
    setCurrentDirectory workingDir
    genCodeWithChoices cs

codedDirName :: String -> Choices -> String
codedDirName n Choices {
  architecture = a,
  logConfig = l,
  dataInfo = d,
  maps = m} = 
  intercalate "_" [n, codedMod $ modularity a, codedImpTp $ impType a, codedLog $ logging l, 
    codedStruct $ inputStructure d, codedConStruct $ constStructure d, 
    codedConRepr $ constRepr d, codedSpaceMatch $ spaceMatch m]

codedMod :: Modularity -> String
codedMod Unmodular = "U"
codedMod (Modular Combined) = "C"
codedMod (Modular Separated) = "S"

codedImpTp :: ImplementationType -> String
codedImpTp Program = "P"
codedImpTp Library = "L"

codedLog :: [Logging] -> String
codedLog [] = "NoL"
codedLog _ = "L"

codedStruct :: Structure -> String
codedStruct Bundled = "B"
codedStruct Unbundled = "U"

codedConStruct :: ConstantStructure -> String
codedConStruct Inline = "I"
codedConStruct WithInputs = "WI"
codedConStruct (Store s) = codedStruct s

codedConRepr :: ConstantRepr -> String
codedConRepr Var = "V"
codedConRepr Const = "C"

codedSpaceMatch :: SpaceMatch -> String
codedSpaceMatch sm = case sm Real of [Double, Float] -> "D"
                                     [Float, Double] -> "F" 
                                     _ -> error 
                                       "Unexpected SpaceMatch for Projectile"

choiceCombos :: [Choices]
choiceCombos = [baseChoices, 
  baseChoices {
    architecture = makeArchit (Modular Combined) Program,
    dataInfo = makeData Bundled (Store Unbundled) Var
  },
  baseChoices {
    architecture = makeArchit (Modular Separated) Library,
    dataInfo = makeData Unbundled (Store Unbundled) Var,
    maps = makeMaps (matchConcepts [(piConst, [Pi])]) matchToFloats
  },
  baseChoices {
    logConfig = makeLogConfig [LogVar, LogFunc] "log.txt",
    dataInfo = makeData Bundled (Store Bundled) Const
  },
  baseChoices {
    logConfig = makeLogConfig [LogVar, LogFunc] "log.txt",
    dataInfo = makeData Bundled WithInputs Var,
    maps = makeMaps (matchConcepts [(piConst, [Pi])]) matchToFloats
  }]

matchToFloats :: SpaceMatch
matchToFloats = matchSpaces (map (,[Float, Double]) [Real, Radians, Rational])

baseChoices :: Choices
baseChoices = defaultChoices {
  lang = [Python, Cpp, CSharp, Java, Swift],
  architecture = makeArchit Unmodular Program,
  dataInfo = makeData Unbundled WithInputs Var,
  logConfig = makeLogConfig [] "log.txt",
  docConfig = makeDocConfig [CommentFunc, CommentClass, CommentMod] Quiet Hide,
  srsConstraints = makeConstraints Warning Warning,
  maps = makeMaps (matchConcepts [(piConst, [Pi])]) spaceToCodeType,
  auxFiles = [SampleInput "../../../datafiles/projectile/sampleInput.txt", ReadME]
}
