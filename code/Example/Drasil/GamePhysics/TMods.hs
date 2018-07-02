module Drasil.GamePhysics.TMods (cpTMods, t1NewtonSL_new, t2NewtonTL_new, 
t3NewtonLUG_new, t4ChaslesThm_new, t5NewtonSLR_new) where

import Drasil.GamePhysics.Unitals (dispNorm, dispUnit, force_1, force_2,
  mass_1, mass_2, r_OB, sqrDist, vel_B, vel_O)

import Language.Drasil
import Data.Drasil.SentenceStructures (foldlSent)
import qualified Data.Drasil.Concepts.Physics as CP (rigidBody)
import qualified Data.Drasil.Quantities.PhysicalProperties as QPP (mass)
import qualified Data.Drasil.Quantities.Physics as QP (acceleration, 
  angularAccel, angularVelocity, displacement, force, gravitationalConst, 
  momentOfInertia, torque, velocity)
import Prelude hiding (id)
import Control.Lens ((^.))
import Data.Drasil.Utils(getES)

----- Theoretical Models -----

cpTMods :: [RelationConcept]
cpTMods = [newtonSL, newtonTL, newtonLUG, chaslesThm, newtonSLR]

-- T1 : Newton's second law of motion --

t1NewtonSL_new :: TheoryModel
t1NewtonSL_new = tm' (cw t1NewtonSL)
  (tc' "NewtonSL" [qw QP.force, qw QPP.mass, qw QP.acceleration] ([] :: [ConceptChunk])
  [] [TCon Invariant $ (sy QP.force) $= (sy QPP.mass) * (sy QP.acceleration)] []) "NewtonSecLawMot" 
  [newtonSLDesc]

t1NewtonSL :: RelationConcept
t1NewtonSL = makeRC "t1NewtonSL" (nounPhraseSP "Newton's second law of motion")
  newtonSLDesc newtonSLRel

newtonSLRel :: Relation
newtonSLRel = (sy QP.force) $= (sy QPP.mass) * (sy QP.acceleration)

newtonSLDesc :: Sentence
newtonSLDesc = foldlSent [S "The net", (phrase QP.force), (getES QP.force),
  (sParen $ Sy $ unit_symb QP.force), S "on a", (phrase CP.rigidBody),
  S "is proportional to the", (phrase QP.acceleration),
  (getES QP.acceleration), (sParen $ Sy $ unit_symb QP.acceleration),
  S "of the", (phrase CP.rigidBody) `sC`
  S "where", (getES QPP.mass), (sParen $ Sy $ unit_symb QPP.mass),
  S "denotes the", (phrase QPP.mass), S "of the",
  (phrase $ CP.rigidBody),
  S "as the constant of proportionality"]

-- T2 : Newton's third law of motion --

t2NewtonTL_new :: TheoryModel
t2NewtonTL_new = tm' (cw t2NewtonTL)
  (tc' "NewtonTL" [qw force_1, qw force_2] ([] :: [ConceptChunk])
  [] [TCon Invariant $ (sy force_1) $= (negate (sy force_2))] [] ) "NewtonThirdLawMot"
  [newtonTLDesc]

t2NewtonTL :: RelationConcept
t2NewtonTL = makeRC "t2NewtonTL" (nounPhraseSP "Newton's third law of motion")
  newtonTLDesc newtonTLRel

newtonTLRel :: Relation
newtonTLRel = (sy force_1) $= (negate (sy force_2))

newtonTLDesc :: Sentence
newtonTLDesc = foldlSent [S "Every action has an equal and opposite reaction. In other",
  S "words, the", (phrase QP.force), (getES force_1),
  (sParen $ Sy $ unit_symb force_1), S "exerted on the second",
  (phrase CP.rigidBody), S "by the first is equal in magnitude and",
  S "in the opposite direction to the", (phrase QP.force),
  (getES force_2), (sParen $ Sy $ unit_symb force_2),
  S "exerted on the first", (phrase CP.rigidBody), S "by the second"]

-- T3 : Newton's law of universal gravitation --

t3NewtonLUG_new :: TheoryModel
t3NewtonLUG_new = tm' (cw t3NewtonLUG)
  (tc' "NewtonLUG" [qw QP.force, qw QP.gravitationalConst, qw mass_1, qw mass_2,
  qw dispNorm, qw dispUnit, qw QP.displacement] ([] :: [ConceptChunk])
  [] [TCon Invariant $ (sy QP.force) $= (sy QP.gravitationalConst) * ((sy mass_1) * 
  (sy mass_2) / ((sy dispNorm) $^ (fromInteger 2))) * (sy dispUnit) $= 
  (sy QP.gravitationalConst) * ((sy mass_1) * (sy mass_2) / ((sy dispNorm) 
  $^ (fromInteger 2))) * ((sy QP.displacement) / (sy dispNorm))] [] ) "UniversalGravLaw"
  [newtonLUGDesc]

t3NewtonLUG :: RelationConcept
t3NewtonLUG = makeRC "t3NewtonLUG" 
  (nounPhraseSP "Newton's law of universal gravitation") newtonLUGDesc newtonLUGRel

newtonLUGRel :: Relation
newtonLUGRel = (sy QP.force) $=
  (sy QP.gravitationalConst) * ((sy mass_1) * (sy mass_2) /
  ((sy dispNorm) $^ (fromInteger 2))) * (sy dispUnit) $=
  (sy QP.gravitationalConst) * ((sy mass_1) * (sy mass_2) /
  ((sy dispNorm) $^ (fromInteger 2))) * ((sy QP.displacement) / (sy dispNorm))

-- Can't include fractions within a sentence (in the part where 'r denotes the
-- unit displacement vector, equivalent to r/||r||' (line 184)). Changed to a
-- verbal description instead.

-- Can't properly include the gravitational constant in a sentence (in the last
-- sentence, supposed to include "6.673 * 10^{-11} m/kgs^2" (line 187)).

newtonLUGDesc :: Sentence
newtonLUGDesc = foldlSent [S "Two", (plural CP.rigidBody), S "in the universe",
  S "attract each other with a", (phrase QP.force), 
  (getES QP.force), (sParen $ Sy $ unit_symb QP.force),
  S "that is directly proportional to the product of their",
  (plural QPP.mass) `sC` (getES mass_1), S "and",
  (getES mass_2), (sParen $ Sy $ unit_symb QPP.mass) `sC` S "and",
  S "inversely proportional to the", (phrase $ sqrDist),
  (getES sqrDist), (sParen $ Sy $ unit_symb sqrDist),
  S "between them. The vector", (getES QP.displacement), 
  (sParen $ Sy $ unit_symb QP.displacement), S "is the", 
  (phrase QP.displacement), S "between the centres of the", 
  (plural CP.rigidBody), S "and", (getES dispNorm), 
  (sParen $ Sy $ unit_symb dispNorm), S "represents the" +:+. 
  ((phrase dispNorm) `sC` S "or absolute distance between the two"), 
  (getES dispUnit), S "denotes the", (phrase $ dispUnit) `sC` 
  S "equivalent to the", (phrase QP.displacement), 
  S "divided by the" +:+. ((phrase dispNorm) `sC`
  S "as shown above"), S "Finally" `sC` (getES QP.gravitationalConst), 
  S "is the", (QP.gravitationalConst ^. defn), 
  (sParen $ Sy $ unit_symb QP.gravitationalConst)]

-- T4 : Chasles' theorem --

t4ChaslesThm_new :: TheoryModel
t4ChaslesThm_new = tm' (cw t4ChaslesThm)
  (tc' "ChaslesThm" [qw vel_B, qw vel_O, qw QP.angularVelocity, qw r_OB] 
  ([] :: [ConceptChunk]) [] [TCon Invariant $ (sy vel_B) $= (sy vel_O) + (cross 
  (sy  QP.angularVelocity) (sy r_OB))] []) "ChaslesTheorem"
  [chaslesThmDesc]

t4ChaslesThm :: RelationConcept
t4ChaslesThm = makeRC "t4ChaslesThm" (nounPhraseSP "Chasles' theorem")
  chaslesThmDesc chaslesThmRel

-- Need the cross product symbol - third term should be a cross product.
chaslesThmRel :: Relation
chaslesThmRel = (sy vel_B) $= (sy vel_O) + (cross (sy  QP.angularVelocity) (sy r_OB))

-- B should ideally be italicized in 'point B' (line 202).
chaslesThmDesc :: Sentence
chaslesThmDesc = foldlSent [S "The linear", (phrase QP.velocity),
  (getES vel_B), (sParen $ Sy $ unit_symb vel_B), S "of any point B in a",
  (phrase CP.rigidBody), S "is the sum of the linear",
  (phrase QP.velocity), (getES vel_O),
  (sParen $ Sy $ unit_symb vel_O), S "of the", (phrase $ CP.rigidBody),
  S "at the origin (axis of rotation) and the",
  S "resultant vector from the cross product of the",
  (phrase CP.rigidBody) :+: S "'s", (phrase QP.angularVelocity),
  (getES QP.angularVelocity),
  (sParen $ Sy $ unit_symb  QP.angularVelocity), S "and the",
  (phrase r_OB) `sC` (getES r_OB),
  (sParen $ Sy $ unit_symb r_OB)]

-- T5 : Newton's second law for rotational motion --

t5NewtonSLR_new :: TheoryModel
t5NewtonSLR_new = tm' (cw t5NewtonSLR)
  (tc' "NewtonSLR" [qw QP.torque, qw QP.momentOfInertia, qw QP.angularAccel] 
  ([] :: [ConceptChunk]) [] [TCon Invariant $ (sy  QP.torque) $= (sy QP.momentOfInertia) 
  * (sy QP.angularAccel)] []) "NewtonSecLawRotMot"
  [newtonSLRDesc]

t5NewtonSLR :: RelationConcept
t5NewtonSLR = makeRC "t5NewtonSLR" 
  (nounPhraseSP "Newton's second law for rotational motion") newtonSLRDesc newtonSLRRel

newtonSLRRel :: Relation
newtonSLRRel = (sy  QP.torque) $= (sy QP.momentOfInertia) * (sy QP.angularAccel)

-- Need reference to A2 (line 236) -- can't reference specific assumptions
-- without referencing the entire section or dividing each bullet into its own
-- section.
newtonSLRDesc :: Sentence
newtonSLRDesc = foldlSent [S "The net", (phrase QP.torque),
  (getES QP.torque),
  (sParen $ Sy $ unit_symb  QP.torque), S "on a", (phrase CP.rigidBody),
  S "is proportional to its", (phrase QP.angularAccel),
  (getES QP.angularAccel) +:+. (sParen $ Sy $ unit_symb QP.angularAccel),
  S "Here" `sC` (getES QP.momentOfInertia),
  (sParen $ Sy $ unit_symb QP.momentOfInertia),
  S "denotes the", (phrase QP.momentOfInertia), S "of the" +:+.
  (phrase CP.rigidBody), S "We also assume that all",
  (plural CP.rigidBody), S "involved are two-dimensional (A2)"]
