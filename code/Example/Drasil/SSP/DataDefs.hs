module Drasil.SSP.DataDefs where
--(sspDataDefs) FIXME: weaves derivations in body.hs

import Prelude hiding (cos, sin, tan)
import Language.Drasil

import Drasil.SSP.Unitals (shrStiffBase, index, genDisplace, baseAngle, inxi,
  nrmStiffBase, effStiffA, effStiffB, rotatedDispl, genPressure, shrStiffIntsl,
  nrmStiffIntsl, nrmFNoIntsl, shearFNoIntsl, shearRNoIntsl, impLoadAngle,
  surfLoad, surfAngle, surfHydroForce, watrForceDif, slcWght, earthqkLoadFctr,
  inxiM1, mobShrI, wiif, intShrForce, intNormForce, baseWthX, cohesion,
  fricAngle, baseHydroForce, watrForce, nrmFSubWat, shrResI, constant_A,
  nrmDispl, constant_K, constant_a, normStress, poissnsRatio, inx, surfLngth,
  baseLngth, genForce, shrDispl, scalFunc, normToShear, slipDist, slopeDist,
  slopeHght, slipHght, waterHght, satWeight, waterWeight, dryWeight)
import Drasil.SSP.GenDefs (eqlExpr, displMtx, rotMtx)
import Drasil.SSP.Defs (intrslce)

import Data.Drasil.Utils (getS, mkDataDef)
import Data.Drasil.Quantities.SolidMechanics as SM (poissnsR)

-- Needed for derivations
import Data.Drasil.Concepts.Documentation (definition, element, value)
import Data.Drasil.SentenceStructures (sAnd, sOf,
  foldlSP, eqN, isThe, acroDD, acroGD, acroT,
  ofThe, getTandS, ofThe')
import Control.Lens ((^.))
import Data.Drasil.Concepts.Math (equation, angle)

------------------------
--  Data Definitions  --
------------------------

sspDataDefs :: [QDefinition]
sspDataDefs = [sliceWght, baseWtrF, surfWtrF, intersliceWtrF, angleA, angleB,
  lengthB, lengthLb, lengthLs, seismicLoadF, surfLoads, intrsliceF, resShearWO,
  mobShearWO, displcmntRxnF, displcmntBasel, netFDsplcmntEqbm, shearStiffness,
  soilStiffness]

--DD1

sliceWght :: QDefinition
sliceWght = mkDataDef slcWght slcWgtEqn

slcWgtEqn :: Expr
slcWgtEqn = (inxi baseWthX) * (Case [case1,case2,case3])
  where case1 = (((inxi slopeHght)-(inxi slipHght ))*(C satWeight),
          (inxi waterHght) :>= (inxi slopeHght))

        case2 = (((inxi slopeHght)-(inxi waterHght))*(C dryWeight) +
          ((inxi waterHght)-(inxi slipHght))*(C satWeight),
          (inxi slopeHght) :> (inxi waterHght) :> (inxi slipHght))

        case3 = (((inxi slopeHght)-(inxi slipHght ))*(C dryWeight),
          (inxi waterHght) :<= (inxi slipHght))

--DD2

baseWtrF :: QDefinition
baseWtrF = mkDataDef baseHydroForce bsWtrFEqn 

bsWtrFEqn :: Expr
bsWtrFEqn = (inxi baseLngth)*(Case [case1,case2])
  where case1 = (((inxi waterHght)-(inxi slipHght))*(C waterWeight),
          (inxi waterHght) :> (inxi slipHght))

        case2 = (Int 0, (inxi waterHght) :<= (inxi slipHght))

--DD3

surfWtrF :: QDefinition
surfWtrF = mkDataDef surfHydroForce surfWtrFEqn

surfWtrFEqn :: Expr
surfWtrFEqn = (inxi surfLngth)*(Case [case1,case2])
  where case1 = (((inxi waterHght)-(inxi slopeHght))*(C waterWeight),
          (inxi waterHght) :> (inxi slopeHght))

        case2 = (Int 0, (inxi waterHght) :<= (inxi slopeHght))

--DD4

intersliceWtrF :: QDefinition
intersliceWtrF = mkDataDef watrForce intersliceWtrFEqn

intersliceWtrFEqn :: Expr
intersliceWtrFEqn = Case [case1,case2,case3]
  where case1 = (((inxi slopeHght)-(inxi slipHght )):^ 2 :/ 2  *
          (C satWeight) + ((inxi waterHght)-(inxi slopeHght)):^ 2 *
          (C satWeight), (inxi waterHght) :>= (inxi slopeHght))

        case2 = (((inxi waterHght)-(inxi slipHght )):^ 2 :/ 2  * (C satWeight),
                (inxi slopeHght) :> (inxi waterHght) :> (inxi slipHght))

        case3 = (Int 0,(inxi waterHght) :<= (inxi slipHght))

--DD5

angleA :: QDefinition
angleA = mkDataDef baseAngle angleAEqn

angleAEqn :: Expr
angleAEqn = (inxi slipHght - inx slipHght (-1)) /
  (inxi slipDist - inx slipDist (-1))

--DD5.5
angleB :: QDefinition
angleB = mkDataDef surfAngle angleBEqn

angleBEqn :: Expr
angleBEqn = (inxi slopeHght - inx slopeHght (-1)) /
  (inxi slopeDist - inx slopeDist (-1))

--DD6

lengthB :: QDefinition
lengthB = mkDataDef baseWthX lengthBEqn

lengthBEqn :: Expr
lengthBEqn = inxi slipDist - inx slipDist (-1)

--DD6.3

lengthLb :: QDefinition
lengthLb = mkDataDef baseLngth lengthLbEqn

lengthLbEqn :: Expr
lengthLbEqn = (inxi baseWthX) * sec (inxi baseAngle)
--DD6.6

lengthLs :: QDefinition
lengthLs = mkDataDef surfLngth lengthLsEqn

lengthLsEqn :: Expr
lengthLsEqn = (inxi baseWthX) * sec (inxi surfAngle)

--DD7

seismicLoadF :: QDefinition
seismicLoadF = mkDataDef earthqkLoadFctr ssmcLFEqn
  --FIXME: K_E missing for unitals?

ssmcLFEqn :: Expr
ssmcLFEqn = ((C earthqkLoadFctr) * (inxi slcWght))

--DD8

surfLoads :: QDefinition
surfLoads = mkDataDef surfLoad surfLEqn
  --FIXEME: is this data definition necessary?

surfLEqn :: Expr
surfLEqn = (inxi surfLoad) * (inxi impLoadAngle)
  --FIXME: should be split into two DataDefs

--DD9

intrsliceF :: QDefinition
intrsliceF = mkDataDef intShrForce intrsliceFEqn

intrsliceFEqn :: Expr
intrsliceFEqn = (C normToShear) * (inxi scalFunc) * (inxi intNormForce)

--DD10

resShearWO :: QDefinition
resShearWO = mkDataDef shearRNoIntsl resShearWOEqn

resShearWOEqn :: Expr
resShearWOEqn = (((inxi slcWght) + (inxi surfHydroForce) *
  (cos (inxi surfAngle)) + (inxi surfLoad) * (cos (inxi impLoadAngle))) *
  (cos (inxi baseAngle)) + (Neg (C earthqkLoadFctr) * (inxi slcWght) -
  (inxi watrForceDif) + (inxi surfHydroForce) :* sin (inxi surfAngle) +
  (inxi surfLoad) * (sin (inxi impLoadAngle))) * (sin (inxi baseAngle)) -
  (inxi baseHydroForce)) * tan (inxi fricAngle) + (inxi cohesion) *
  (inxi baseWthX) * sec (inxi baseAngle)

--DD11

mobShearWO :: QDefinition
mobShearWO = mkDataDef shearFNoIntsl mobShearWOEqn

mobShearWOEqn :: Expr 
mobShearWOEqn = ((inxi slcWght) + (inxi surfHydroForce) *
  (cos (inxi surfAngle)) + (inxi surfLoad) * (cos (inxi impLoadAngle))) *
  (sin (inxi baseAngle)) - (Neg (C earthqkLoadFctr) * (inxi slcWght) -
  (inxi watrForceDif) + (inxi surfHydroForce) :* sin (inxi surfAngle) +
  (inxi surfLoad) * (sin (inxi impLoadAngle))) * (cos (inxi baseAngle))

--DD12

displcmntRxnF :: QDefinition
displcmntRxnF = mkDataDef genPressure displcmntRxnFEqn

displcmntRxnFEqn :: Expr
displcmntRxnFEqn = dgnl2x2 (inxi shrStiffIntsl) (inxi nrmStiffBase) * displMtx

--DD12.5
displcmntBasel :: QDefinition
displcmntBasel = mkDataDef genPressure displcmntBaselEqn

displcmntBaselEqn :: Expr
displcmntBaselEqn = m2x2 (inxi effStiffA) (inxi effStiffB) (inxi effStiffB)
  (inxi effStiffA) * displMtx

--DD13

netFDsplcmntEqbm :: QDefinition
netFDsplcmntEqbm = mkDataDef genForce netFDsplcmntEqbmEqn

netFDsplcmntEqbmEqn :: Expr
netFDsplcmntEqbmEqn = Neg (inx surfLngth (-1)) * (inx nrmStiffIntsl (-1)) *
  (inx genDisplace (-1)) + (inx surfLngth (-1) * inx nrmStiffIntsl (-1) +
  inx baseLngth 0 * inx nrmStiffBase 0 + inx surfLngth 0 *
  inx nrmStiffIntsl 0) * (inx genDisplace 0) -
  (inx surfLngth 0) * (inx nrmStiffIntsl 0) * (inx genDisplace 1)

--DD14

shearStiffness :: QDefinition
shearStiffness = mkDataDef shrStiffBase shearStiffnessEqn  

shearStiffnessEqn :: Expr
shearStiffnessEqn = C intNormForce / (Int 2 * (Int 1 + C poissnsRatio)) *
  (Dbl 0.1 / C baseWthX) + (inxi cohesion - C normStress *
  tan(inxi fricAngle)) / (abs (C shrDispl) + C constant_a)

--DD15 this is the second part to the original DD14

soilStiffness :: QDefinition
soilStiffness = mkDataDef nrmStiffBase soilStiffnessEqn

soilStiffnessEqn :: Expr
soilStiffnessEqn = (Case [case1,case2])
  where case1 = (block, (C SM.poissnsR) :< 0)

        case2 = ((Dbl 0.01) * block + (C constant_K) / ((C nrmDispl)+
          (C constant_A)), (C SM.poissnsR) :>= 0)

        block = (C intNormForce)*(1 - (C SM.poissnsR))/
          ((1 + (C SM.poissnsR)) * (1 - 2 :*(C SM.poissnsR) + (C baseWthX)))

-----------------
-- Derivations --
-----------------

-- FIXEME: move derivations with the appropriate data definition

resShrDerivation :: [Contents]
resShrDerivation = [

  foldlSP [S "The", phrase shrResI, S "of a slice is", 
  S "defined as", getS shrResI, S "in" +:+. acroGD 3, S "The",
  phrase nrmFSubWat, S "in the", phrase equation, S "for", getS shrResI,
  S "of the soil is defined in the perpendicular force equilibrium",
  S "of a slice from", acroGD 2 `sC` S "using the", getTandS nrmFSubWat,
  S "of", acroT 4, S "shown in", eqN 1],
  
  EqnBlock $ (inxi nrmFSubWat) := eqlExpr cos sin (\x y -> x -
  inxiM1 intShrForce + inxi intShrForce + y) - inxi baseHydroForce,
  
  foldlSP [plural value `ofThe'` S "interslice forces",
  getS intNormForce `sAnd` getS intShrForce, S "in the", phrase equation,
  S "are unknown, while the other", plural value,
  S "are found from the physical force", plural definition, S "of",
  acroDD 1, S "to" +:+. acroDD 9,
  S "Consider a force equilibrium without the affect of interslice forces" `sC`
  S "to obtain a solvable value as done for", getS nrmFNoIntsl, S "in", eqN 2],

  EqnBlock $
  (inxi nrmFNoIntsl) := (((inxi slcWght) + (inxi surfHydroForce) *
  (cos (inxi surfAngle)) + (inxi surfLoad) * (cos (inxi impLoadAngle))) *
  (cos (inxi baseAngle)) + (Neg (C earthqkLoadFctr) * (inxi slcWght) -
  (inxi watrForce) + (inxiM1 watrForce) + (inxi surfHydroForce) *
  sin (inxi surfAngle) + (inxi surfLoad) * (sin (inxi impLoadAngle))) *
  (sin (inxi baseAngle)) - (inxi baseHydroForce)),
  
  foldlSP [S "Using", getS nrmFNoIntsl `sC` S "a", phrase shearRNoIntsl,
  shearRNoIntsl ^. defn, S "can be solved for in terms of all known",
  phrase value, S "as done in", eqN 3],
  
  EqnBlock $
  inxi shearRNoIntsl := (inxi nrmFNoIntsl) * tan (inxi fricAngle) +
  (inxi cohesion) * (inxi baseWthX) * sec (inxi baseAngle) :=
  (((inxi slcWght) + (inxi surfHydroForce) * (cos (inxi surfAngle)) +
  (inxi surfLoad) * (cos (inxi impLoadAngle))) * (cos (inxi baseAngle)) +
  (Neg (C earthqkLoadFctr) * (inxi slcWght) - (inxi watrForceDif) +
  (inxi surfHydroForce) * sin (inxi surfAngle) + (inxi surfLoad) *
  (sin (inxi impLoadAngle))) * (sin (inxi baseAngle)) -
  (inxi baseHydroForce)) * tan (inxi fricAngle) + (inxi cohesion) *
  (inxi baseWthX) * sec (inxi baseAngle)

  ]

mobShrDerivation :: [Contents]
mobShrDerivation = [

  foldlSP [S "The", phrase mobShrI, S "acting on a slice is defined as",
  getS mobShrI, S "from the force equilibrium in", acroGD 2 `sC`
  S "also shown in", eqN 4],
  
  EqnBlock $ inxi mobShrI := eqlExpr sin cos
    (\x y -> x - inxiM1 intShrForce + inxi intShrForce + y),
  
  foldlSP [S "The", phrase equation, S "is unsolvable, containing the unknown",
  getTandS intNormForce, S "and" +:+. getTandS intShrForce,
  S "Consider a force equilibrium", S wiif `sC` S "to obtain the",
  getTandS shearFNoIntsl `sC` S "as done in", eqN 5],
  
  EqnBlock $
  inxi shearFNoIntsl := ((inxi slcWght) :+ (inxi surfHydroForce) :*
  (cos (inxi surfAngle)) :+ (inxi surfLoad) :* (cos (inxi impLoadAngle))) :*
  (sin (inxi baseAngle)) :- (Neg (C earthqkLoadFctr) :* (inxi slcWght) :-
  (inxi watrForceDif) :+ (inxi surfHydroForce) :* sin (inxi surfAngle) :+
  (inxi surfLoad) :* (sin (inxi impLoadAngle))) :* (cos (inxi baseAngle)),
  
  foldlSP [S "The", plural value, S "of", getS shearRNoIntsl `sAnd`
  getS shearFNoIntsl, S "are now defined completely in terms of the",
  S "known force property", plural value, S "of", acroDD 1, S "to", acroDD 9]

  ]

kiStar :: Expr
kiStar = m2x2 (inxi shrStiffBase * cos(inxi baseAngle))
  (Neg $ inxi nrmStiffBase * sin(inxi baseAngle)) (inxi shrStiffBase *
  sin(inxi baseAngle)) (inxi nrmStiffBase * cos(inxi baseAngle))
  
kiPrime :: Expr
kiPrime = m2x2
  (inxi shrStiffBase * cos(inxi baseAngle) :^ 2 + inxi nrmStiffIntsl *
  sin(inxi baseAngle) :^ 2) ((inxi shrStiffBase - inxi nrmStiffBase) *
  sin(inxi baseAngle) * cos(inxi baseAngle)) ((inxi shrStiffBase -
  inxi nrmStiffBase) * sin(inxi baseAngle) * cos(inxi baseAngle))
  (inxi shrStiffBase * cos(inxi baseAngle) :^ 2 + inxi nrmStiffIntsl *
  sin(inxi baseAngle) :^ 2)
  
stfMtrxDerivation :: [Contents]
stfMtrxDerivation = [

  foldlSP [S "Using the force-displacement relationship of", 
  acroGD 8, S "to define stiffness matrix", getS shrStiffIntsl `sC`
  S "as seen in", eqN 6],
  
  EqnBlock $ inxi shrStiffIntsl :=
  dgnl2x2 (inxi shrStiffIntsl) (inxi nrmStiffBase),
  
  foldlSP [S "For interslice surfaces the stiffness constants" `sAnd`
  S "displacements refer to an unrotated coordinate system" `sC`
  getS genDisplace, S "of" +:+. acroGD 9, S "The interslice elements",
  S "are left in their standard coordinate system" `sC`
  S "and therefore are described by the same", phrase equation,
  S "from" +:+. acroGD 8, S "Seen as", getS shrStiffIntsl, S "in" +:+.
  acroDD 12, isElMx shrStiffIntsl "shear" `sC` --FIXEME: add matrix symbols?
  S "and", isElMx nrmStiffIntsl "normal" `sC` S "calculated as in", acroDD 14],
  
  foldlSP [S "For basal surfaces the stiffness constants" `sAnd`
  S "displacements refer to a system rotated for the base angle alpha" +:+.
  sParen (acroDD 5), S "To analyze the effect of force-displacement",
  S "relationships occurring on both basal" `sAnd`
  S "interslice surfaces of an", phrase element, getS index,
  S "they must reference the same coordinate",
  S "system. The basal stiffness matrix must be rotated counter clockwise",
  S "to align with" +:+. (phrase angle `ofThe` S "basal surface"),
  S "The base stiffness counter clockwise rotation is applied in", eqN 7,
  S "to the new matrix", getS nrmFNoIntsl],
  
  EqnBlock $ inxi shrStiffIntsl :=
  m2x2 (cos(inxi baseAngle)) (Neg $ sin(inxi baseAngle))
  (sin(inxi baseAngle)) (cos(inxi baseAngle)) *
  inxi shrStiffIntsl := kiStar,
  
  foldlSP [S "The Hooke's law force displacement relationship of", acroGD 8,
  S "applied to the base also references a displacement vector",
  getS rotatedDispl, S "of", acroGD 9, S "rotated for", S "base angle" `ofThe`
  S "slice", getS baseAngle +:+. S "The basal displacement vector",
  getS genDisplace,  S "is rotated clockwise to align with the",
  phrase intrslce, S "displacement vector",
  getS genDisplace `sC` S "applying the", phrase definition, S "of", 
  getS rotatedDispl, S "in terms of", getS genDisplace, S "as seen in" +:+.
  acroGD 9, S "Using this with base stiffness matrix",
  getS shrStiffBase --FIXME: should be K*i"
  `sC` S "a basal force displacement relationship in the same coordinate",
  S "system as the interslice relationship can be derived as done in", eqN 8],
  
  EqnBlock $ vec2D (inxi genPressure) (inxi genPressure) :=
  inxi shrStiffBase * C rotatedDispl := --FIXME: add more symbols?
  kiStar * rotMtx * displMtx := kiPrime * displMtx,
  
  foldlSP [S "The new effective base stiffness matrix", getS shrStiffBase,
  --FIXME: add symbol?
  S "as derived in", eqN 7, S "is defined in" +:+. eqN 9,
  S "This is seen as matrix", getS shrStiffBase, S "in" +:+.
  acroGD 12, isElMx shrStiffBase "shear" `sC` S "and",
  isElMx nrmStiffBase "normal" `sC` S "calculated as in" +:+. acroDD 14,
  S "The notation is simplified by", S "introduction" `ofThe` S "constants",
  getS effStiffA `sAnd` getS effStiffB `sC` S "defined in", eqN 10 `sAnd`
  eqN 11, S "respectively"],
  
  EqnBlock $ inxi shrStiffBase := kiPrime
  := m2x2 (inxi effStiffA) (inxi effStiffB) (inxi effStiffB) (inxi effStiffA),
  
  EqnBlock $
  (inxi effStiffA) := (inxi shrStiffBase) * (cos (inxi baseAngle)) :^ 2 :+
  (inxi nrmStiffBase) * (sin (inxi baseAngle)) :^ 2,
  
  EqnBlock $
  (inxi effStiffB) := ((inxi shrStiffBase)-(inxi nrmStiffBase)) *
  (sin (inxi baseAngle)) * (cos (inxi baseAngle)),
  
  foldlSP [S "A force-displacement relationship for an element", getS index,
  S "can be written in terms of displacements occurring in the unrotated", 
  S "coordinate system", getS genDisplace `sOf` acroGD 9, S "using the matrix",
  getS shrStiffBase `sC` --FIXME: index 
  S "and", getS shrStiffBase, S "as seen in", acroDD 12]
  
  ]

isElMx :: (Quantity a) => a -> String -> Sentence
isElMx sym kword = getS sym `isThe` S kword +:+ S "element in the matrix"