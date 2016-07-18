{-# OPTIONS -Wall #-}
{-# LANGUAGE FlexibleContexts #-} 
module Example.Drasil.GlassBR.GlassBRExample where

import Example.Drasil.GlassBR.GlassBRSIUnits
import Example.Drasil.GlassBR.GlassBRUnits

import Language.Drasil

import Control.Lens((^.))
import Data.Char(toLower)

glassBRSymbols :: [UnitalChunk]
glassBRSymbols = [plate_len, risk_fun, plate_width, dim_max, dim_min, 
  mod_elas, glass_type, act_thick, is_safe1, is_safe2, sdf, sdf_tol, 
  sflawParamK, sflawParamM, prob_br, pb_tol, demand, dimlessLoad, tolLoad,
  sd, sd_max, sd_min, nom_thick, load_dur, char_weight, cWeightMax, 
  cWeightMin, eqTNTWeight]

plate_len, risk_fun, plate_width, dim_max, dim_min, mod_elas,glass_type,
  act_thick, is_safe1, is_safe2, sdf, sdf_tol, sflawParamK, sflawParamM, 
  prob_br, pb_tol, demand, dimlessLoad, tolLoad, sd, sdx, sdy, sdz, sd_max, 
  sd_min, nom_thick, load_dur, char_weight, cWeightMax, cWeightMin, 
  eqTNTWeight, tNT, lRe, loadSF, ar, ar_max, ar_min, gTF:: UnitalChunk

plate_len   = makeUC "a" "Plate length (long dimension)" lA millimetre
plate_width = makeUC "b" "Plate width (short dimension)" lB millimetre
dim_max     = makeUC "d_max" ("Maximum value for one of the dimensions of " ++
  "the glass plate") (sub lD (Atomic "max")) millimetre
dim_min     = makeUC "d_min" ("Minimum value for one of the dimensions of " ++
  "the glass plate") (sub lD (Atomic "min")) millimetre
mod_elas    = makeUC "E" "Modulus of elasticity of glass" cE kilopascal
act_thick   = makeUC "h" "Actual thickness" lH millimetre
sflawParamK = makeUC "k" "Surface flaw parameter" lK sFlawPU
sflawParamM = makeUC "m" "Surface flaw parameter" lM sFlawPU
demand      = makeUC "q" "Applied load (demand)" lQ kilopascal
sd          = makeUC "SD" ("Stand off distance which is represented in " ++
  "coordinates (SDx, SDy, SDz)") (Atomic "SD") metre
sdx         = makeUC "SD_x" "Stand off distance (x-component)" 
  (sub (sd ^. symbol) lX) metre
sdy         = makeUC "SD_y" "Stand off distance (y-component)" 
  (sub (sd ^. symbol) lY) metre
sdz         = makeUC "SD_z" "Stand off distance (z-component)" 
  (sub (sd ^. symbol) lZ) metre
sd_max      = makeUC "SD_max" ("Maximum stand off distance permissible " ++
  "for input") (sub (sd ^. symbol) (Atomic "max")) metre
sd_min      = makeUC "SD_min" ("Minimum stand off distance permissible " ++
  "for input") (sub (sd ^. symbol) (Atomic "min")) metre
nom_thick   = makeUC "t" ("Nominal thickness t in {2.5, 2.7, 3.0, 4.0, " ++
  "5.0, 6.0, 8.0, 10.0, 12.0, 16.0, 19.0, 22.0}") lT millimetre
load_dur    = makeUC "t_d" "Duration of load" (sub lT lD) second
char_weight = makeUC "w" "Charge weight" lW kilogram
cWeightMax  = makeUC "w_max" "Maximum permissible input charge weight" 
              (sub (char_weight ^. symbol) (Atomic "max")) kilogram
cWeightMin  = makeUC "w_min" "Minimum permissible input charge weight" 
              (sub (char_weight ^. symbol) (Atomic "min")) kilogram
eqTNTWeight = makeUC "w_TNT" "Explosive Mass in equivalent weight of TNT" 
              (sub (char_weight ^. symbol) (tNT ^. symbol)) kilogram

----Quantities--
risk_fun    = makeUC "B" "Risk function" cB unitless
glass_type  = makeUC "g" "Glass type, g in {AN, HS, FT}" lG unitless
is_safe1    = makeUC "is_safe1" ("True when calculated probability is " ++
  "less than tolerable probability") (Atomic "is_safe1") unitless
is_safe2    = makeUC "is_safe2" ("True when load resistance (capacity) " ++
  "is greater than load (demand)") (Atomic "is_safe2") unitless
sdf         = makeUC "J" "Stress distribution factor (Function)" cJ unitless
sdf_tol     = makeUC "J_tol" ("Stress distribution factor (Function) " ++
  "based on Pbtol") (sub (sdf ^. symbol) (Atomic "tol")) unitless
prob_br     = makeUC "P_b" "Probability of breakage" (sub cP lB) unitless
pb_tol      = makeUC "P_btol" "Tolerable probability of breakage" 
              (sub (prob_br ^. symbol) (Atomic "tol")) unitless
dimlessLoad = makeUC "q_hat" "Dimensionless load" (hat lQ) unitless
tolLoad     = makeUC "q_hat_tol" "Tolerable load" 
  (sub (dimlessLoad ^. symbol) (Atomic "tol")) unitless
tNT         = makeUC "TNT" "TNT equivalent factor" (Atomic "TNT") unitless
lRe         = makeUC "LR" "Load Resistance" (Atomic "LR") unitless
loadSF      = makeUC "LSF" "Load Share Factor" (Atomic "LSF") unitless
ar          = makeUC "AR" "Aspect Ratio" (Atomic "AR") unitless
ar_max      = makeUC "AR_max" "Maximum Aspect Ratio" 
  (sub (ar ^. symbol) (Atomic "max")) unitless
ar_min      = makeUC "AR_min" "Minimum Aspect Ratio" 
  (sub (ar ^. symbol) (Atomic "min")) unitless
gTF         = makeUC "GTF" "Glass Type Factor" (Atomic "GTF") unitless

----Acronyms-----
acronyms :: [ConceptChunk]
acronyms = [assumption,dataDefn,genDefn,goalStmt,instanceMod,likelyChange,
  physSysDescr,requirement,softwareRS,gLassBR,theoreticMod, annealedGlass,
  aspectR,aspectRMax,fullyTGlass,glassTypeFac,heatSGlass,iGlass,lDistriFac,
  lResistance,lShareFac,notApp,nonFactorL,eqTNT]
  
assumption,dataDefn,genDefn,goalStmt,instanceMod,likelyChange,
  physSysDescr,requirement,softwareRS,gLassBR,theoreticMod, annealedGlass,
  aspectR,aspectRMax,fullyTGlass,glassTypeFac,heatSGlass,iGlass,lDistriFac,
  lResistance,lShareFac,notApp,nonFactorL,eqTNT :: ConceptChunk
assumption    = makeCC "A" "Assumption"
dataDefn      = makeCC "DD" "Data Definition"
genDefn       = makeCC "GD" "General Definition"
goalStmt      = makeCC "GS"  "Goal Statement"
instanceMod   = makeCC "IM" "Instance Model"
likelyChange  = makeCC "LC" "Likely Change"
physSysDescr  = makeCC "PS" "Physical System Description"
requirement   = makeCC "R" "Requirement"
softwareRS    = makeCC "SRS" "Software Requirements Specification"
gLassBR       = makeCC "GlassBR" "Glass-BR"
theoreticMod  = makeCC "T" "Theoretical Model"
annealedGlass = makeCC "AN" "Annealed Glass"
aspectR       = makeCC "AR" "Aspect Ratio"
aspectRMax    = makeCC "ARmax" "Maximum Aspect Ratio"
fullyTGlass   = makeCC "FT" "Fully Tempered Glass"
glassTypeFac  = makeCC "GTF" "Glass Type Factor"
heatSGlass    = makeCC "HS" "Heat Strengthened Glass"
iGlass        = makeCC "IG" "Insulating Glass"
lDistriFac    = makeCC "LDF" "Load Distribution Factor"
lResistance   = makeCC "LR" "Load Resistance"
lShareFac     = makeCC "LSF" "Load Share Factor"
notApp        = makeCC "N/A" "Not Applicable"
nonFactorL    = makeCC "NFL" "Non-Factored Load"
eqTNT         = makeCC "TNT" "TNT (Trinitrotoluene) Equivalent Factor"


----Terminology---- 
terms :: [ConceptChunk]
terms = [aR, gbr, lite, glassTy, an, ft, hs, gtf, lateral, load, specDeLoad, 
  lr, ldl, nfl, glassWL, sdl, lsf, pb, specA, blaReGLa, eqTNTChar, sD]

aR, gbr, lite, glassTy, an, ft, hs, gtf, lateral, load, specDeLoad, lr, 
  ldl, nfl, glassWL, sdl, lsf, pb, specA, blaReGLa, eqTNTChar, 
  sD, glaSlab, blast, blastTy, glassGeo, capacity, demandq, 
  safeMessage, notSafe:: ConceptChunk
  
aR            = makeCC "Aspect ratio (AR)" ("The ratio of the long " ++
  "dimension of the glass to the short dimension of the glass. For glass " ++
  "supported on four sides, the aspect ratio is always equal to or greater " ++
  "than 1.0. For glass supported on three sides, the ratio of the length " ++
  "of one of the supported edges perpendicular to the free edge, to the " ++
  "length of the free edge, is equal to or greater than 0.5.")
gbr           = makeCC "Glass breakage" ("The fracture or breakage of " ++
  "any lite or ply in monolithic, laminated, or insulating glass.")
lite          = makeCC "Lite" ("Pieces of glass that are cut, prepared, " ++
  "and used to create the window or door.")
glassTy       = makeCC "Glass Types" ""
an            = makeCC "Annealed (AN) glass" ("A flat, monolithic, glass " ++
  "lite which has uniform thickness where the residual surface stresses " ++
  "are almost zero, as defined in [5] in Reference.")
ft            = makeCC "Fully tempered (FT) glass" ("A flat and monolithic, "
  ++ "glass lite of uniform thickness that has been subjected to a special " ++
  "heat treatment process where the residual surface compression is not " ++
  "less than 69 MPa (10 000 psi) or the edge compression not less than 67 " ++
  "MPa (9700 psi), as defined in [6] in Reference.")
hs            = makeCC "Heat strengthened (HS) glass" ("A flat, monolithic, "
  ++ "glass lite of uniform thickness that has been subjected to a special " ++
  "heat treatment process where the residual surface compression is not " ++
  "less than 24 MPa (3500psi) or greater than 52 MPa (7500 psi), as defined "
  ++ "in [6] in Reference.")
gtf           = makeCC "Glass type factor (GTF)" ("A multiplying factor " ++
  "for adjusting the LR of different glass type, that is, AN, HS, or FT in " ++
  "monolithic glass, LG (Laminated Glass), or IG (Insulating Glass) " ++
  "constructions.")
lateral       = makeCC "Lateral" "Perpendicular to the glass surface."
load          = makeCC "Load" "A uniformly distributed lateral pressure."
specDeLoad    = makeCC "Specified design load" ("The magnitude in kPa " ++
  "(psf), type (for example, wind or snow) and duration of the load given " ++
  "by the specifying authority.")
lr            = makeCC "Load resistance (LR)" ("The uniform lateral load " ++ 
  "that a glass construction can sustain based upon a given probability " ++
  "of breakage and load duration as defined in [4] in Reference.")
ldl           = makeCC "Long duration load" ("Any load lasting approximately "
  ++ "30 days.")
nfl           = makeCC "Non-factored load (NFL)" ("Three second duration " ++ 
  "uniform load associated with a probability of breakage less than or " ++
  "equal to 8 lites per 1000 for monolithic AN glass.")
glassWL       = makeCC "Glass weight load" ("The dead load component of " ++
  "the glass weight.")
sdl           = makeCC "Short duration load" "Any load lasting 3s or less."
lsf           = makeCC "Load share factor (LSF)" ("A multiplying factor " ++
  "derived from the load sharing between the double glazing, of equal or " ++
  "different thickness's and types (including the layered behaviour of LG " ++
  "under long duration loads), in a sealed IG unit.")
pb            = makeCC "Probability of breakage (Pb)" ("The fraction of " ++
  "glass lites or plies that would break at the first occurrence of a " ++
  "specified load and duration, typically expressed in lites per 1000.")
specA         = makeCC "Specifying authority" ("The design professional " ++
  "responsible for interpreting applicable regulations of authorities " ++
  "having jurisdiction and considering appropriate site specific factors " ++
  "to determine the appropriate values used to calculate the specified " ++
  "design load, and furnishing other information required to perform this " ++
  "practice.")
blaReGLa      = makeCC "Blast resistant glazing" ("Glazing that provides " ++
  "protection against air blast pressure generated by explosions.")
eqTNTChar     = makeCC "Equivalent TNT charge mass" ("Mass of TNT placed " ++
  "on the ground in a hemisphere that represents the design explosive threat.")
sD            = makeCC "Stand off distance (SD)" ("The distance from the " ++
  "glazing surface to the centroid of a hemispherical high explosive charge.")
glaSlab       = makeCC "Glass slab" "Glass slab"
blast         = makeCC "Blast" "Any kind of man-made explosion"
blastTy       = makeCC "Blast type" ("The blast type input includes " ++
  "parameters like weight of charge, TNT equivalent factor and stand off " ++
  "distance from the point of explosion.")
glassGeo      = makeCC "Glass geometry" ("The glass geometry based inputs " ++
  "include the dimensions of the glass plane, glass type and response type.")
capacity      = makeCC "Capacity" "The load resistance calculated"
demandq       = makeCC "Demand" "3 second duration equivalent pressure"
safeMessage   = makeCC "Safe" ("For the given input parameters, the " ++
  "glass is considered safe.")
notSafe       = makeCC "Not safe" ("For the given input parameters, the " ++
  "glass is NOT considered safe.")

--Theoretical models--
t1SafetyReq :: RelationChunk
t1SafetyReq = makeRC "Safety Requirement-1" t1descr safety_require1_rel

safety_require1_rel :: Relation
safety_require1_rel = (C is_safe1) := (C prob_br) :< (C pb_tol)

--relation within relation

t1descr :: Sentence
t1descr = 
  S "If " :+: (P $ is_safe1 ^. symbol) :+: S " = True, the glass is " :+: 
  S "considered safe. " :+: (P $ is_safe1 ^.symbol) :+: S " and " :+: 
  (P $ is_safe2 ^. symbol) :+: S " (from " :+: 
  (makeRef (Definition (Theory t2SafetyReq))) :+: S ") are either " :+:
  S "both True or both False. " :+: (P $ prob_br ^. symbol) :+: 
  S " is the " :+: (sMap (map toLower) (prob_br ^. descr)) :+: 
  S ", as calculated in " :+: (makeRef (Definition (Theory probOfBr))) :+: 
  S ". " :+: (P $ pb_tol ^. symbol) :+: S " is the " :+: 
  (sMap (map toLower) (pb_tol ^. descr)) :+: S " entered by the user."

t2SafetyReq :: RelationChunk
t2SafetyReq = makeRC "Safety Requirement-2" t2descr safety_require2_rel

safety_require2_rel :: Relation
safety_require2_rel = (C is_safe2) := (C lRe) :> (C demand)

--relation within relation

t2descr :: Sentence
t2descr = 
  S "If " :+: (P $ is_safe2 ^. symbol) :+: S " = True, the glass is " :+:
  S "considered safe. " :+: (P $ is_safe1 ^. symbol) :+: S " (from " :+:
  (makeRef (Definition (Theory t1SafetyReq))) :+: S " and " :+: 
  (P $ is_safe2 ^. symbol) :+: S " are either both True or both False. " :+:   
  (P $ lRe ^. symbol) :+: S " is the " :+: (lRe ^. descr) :+: 
  S " (also called capacity, as defined in " :+: 
  (makeRef (Definition (Theory calOfCap))) :+: S ". " :+: 
  (P $ demand ^. symbol) :+: S " (also referred as the demand) is the " :+:
  S "3 second equivalent pressure, as defined in " :+: 
  (makeRef (Definition (Theory calOfDe))) :+: S "."

--Instance Models--
probOfBr :: RelationChunk
probOfBr = makeRC "Probability of Glass Breakage" pbdescr pb_rel 

pb_rel :: Relation
pb_rel = (C prob_br) := 1 - (V "e") :^ (Neg (V "B"))

pbdescr :: Sentence
pbdescr =
  (P $ prob_br ^. symbol) :+: S " is the calculated " :+: 
    (sMap (map toLower) (prob_br ^. descr)) :+: S ". "  :+: 
    (P $ risk_fun ^. symbol) :+: S " is the " :+: (risk ^. descr) :+: S "."

calOfCap :: RelationChunk
calOfCap = makeRC "Calculation of Capacity(LR)" capdescr cap_rel

cap_rel :: Relation
cap_rel = (C lRe) := ((C nonFL):*(C glaTyFac):*(C loadSF)) 

capdescr :: Sentence
capdescr =
  (P $ lRe ^. symbol) :+: S " is the " :+: (lRe ^. descr) :+: S ", which " :+:
  S "is also called capacity. " :+: (P $ nonFL ^. symbol) :+: S " is the " :+:
  (nonFL ^. descr) :+: S ". " :+: (P $ gTF ^. symbol) :+: S " is the " :+:
  (gTF ^. descr) :+: S ". " :+: (P $ loadSF ^. symbol) :+: S " is the " :+:
  (loadSF ^. descr) :+: S "."

calOfDe :: RelationChunk
calOfDe = makeRC "Calculation of Demand(q)" dedescr de_rel

de_rel :: Relation
de_rel = (C demand) := FCall (C demand) [C eqTNTWeight, C sd] 

dedescr :: Sentence
dedescr = 
  (P $ demand ^. symbol) :+: S " or demand, is the 3 second equivalent " :+:
    S "pressure obtained from Figure 2 by interpolation using stand off " :+:
    S "distance (" :+: (P $ sd ^. symbol) :+: S ") and " :+: 
    (P $ eqTNTWeight ^. symbol) :+: S " as parameters. " :+: 
    (P $ eqTNTWeight ^. symbol) :+: S " is defined as " :+:
    (P $ eqTNTWeight ^. symbol) :+: S " = " :+: (P $ char_weight ^. symbol) :+:
    S " * TNT. " :+: (P $ char_weight ^. symbol) :+: S " is the " :+:
    (sMap (map toLower) (char_weight ^. descr)) :+: S ". " :+: 
    (P $ tNT ^. symbol) :+: S " is the " :+: (tNT ^. descr) :+: S ". " :+: 
    (P $ sd ^.symbol) :+: S " is the stand off distance where " :+:
    (P $ sd ^. symbol) :+: S " = ." --equation in sentence

--Data Definitions--
risk_eq :: Expr
risk_eq = ((C sflawParamK):/(Grouping (((C plate_len):/(Int 1000)):*
  ((C plate_width):/(Int 1000)))):^((C sflawParamM) - (Int 1))):*
  (Grouping ((Grouping ((C mod_elas):*(Int 1000))):*(Grouping ((C act_thick)
  :/(Int 1000))):^(Int 2))):^(C sflawParamM):*(C loadDF):*(V "e"):^(C sdf)

risk :: EqChunk
risk = fromEqn "B" (S "risk of failure") (risk_fun ^. symbol) unitless risk_eq

hFromt_eq :: Expr
hFromt_eq = FCall (C act_thick) [C nom_thick]

hFromt :: EqChunk
hFromt = fromEqn "h" (S " function that maps from the nominal thickness (" :+:
 (P $ nom_thick ^. symbol) :+: S ") to the minimum thickness, as follows: " :+:
  S "h(t) = (t = 2.5 => 2.16 | t = 2.7 => 2.59 | t = 3.0 => 2.92 | t = 4.0 " 
  :+: S "=> 3.78 | t = 5.0 => 4.57 | t = 6.0 => 5.56 | t = 8.0 => 7.42 | " :+:
  S "t = 10.0 => 9.02 | t = 12.0 => 11.91 | t = 16.0 => 15.09 | t = 19.0 " :+:
  S "=> 18.26 | t = 22.0 => 21.44)") (act_thick ^.symbol) millimetre hFromt_eq

loadDF_eq :: Expr 
loadDF_eq = (Grouping ((C load_dur):/(Int 60))):^((C sflawParamM):/(Int 16))

loadDF :: EqChunk
loadDF = fromEqn "LDF" (S "Load Duration Factor") (Atomic "LDF") unitless 
  loadDF_eq

strDisFac_eq :: Expr
strDisFac_eq = FCall (C sdf) [C dimlessLoad, (C plate_len):/(C plate_width)]

strDisFac :: EqChunk
strDisFac = fromEqn "J" (sdf ^. descr) (sdf ^. symbol) unitless strDisFac_eq

nonFL_eq :: Expr
nonFL_eq = ((C tolLoad):*(C mod_elas):*(C act_thick):^(Int 4)):/
  ((Grouping ((C plate_len):*(C plate_width))):^(Int 2))

nonFL :: EqChunk
nonFL = fromEqn "NFL" (S "Non-Factored Load") (Atomic "NFL") unitless nonFL_eq

glaTyFac_eq :: Expr
glaTyFac_eq = FCall (C glaTyFac) [C glass_type]

glaTyFac :: EqChunk
glaTyFac = fromEqn "GTF" (S "function that maps from the glass type (" :+: 
  (P $ glass_type ^. symbol) :+: S ") to a real number, as follows: " :+: 
  (P $ glaTyFac ^.symbol) :+: S "(" :+: (P $ glass_type ^. symbol) :+: 
  S ") = (" :+: (P $ glass_type ^. symbol) :+: S " = AN => 1.0|" :+: 
  (P $ glass_type ^. symbol) :+: S " = FT => 4.0|" :+: 
  (P $ glass_type ^. symbol) :+: S " = HS => 2.0). " :+: S "AN is " :+:
  S "annealed glass. FT is fully tempered glass. HS is heat " :+:
  S "strengthened glass.") (Atomic "GTF") unitless glaTyFac_eq

dL_eq :: Expr
dL_eq = ((C demand):*((Grouping ((C plate_len):*(C plate_width))):^(Int 2)))
  :/((C mod_elas):*((C act_thick):^(Int 4)):*(C glaTyFac))

dL :: EqChunk
dL = fromEqn "q_hat" (dimlessLoad ^. descr) (dimlessLoad ^. symbol) unitless 
  dL_eq

tolPre_eq :: Expr
tolPre_eq = FCall (C tolLoad) [C sdf_tol, (C plate_len):/(C plate_width)]

tolPre :: EqChunk
tolPre = fromEqn "q_hat_tol" (tolLoad ^. descr) (tolLoad ^. symbol) unitless 
  tolPre_eq

tolStrDisFac_eq :: Expr
tolStrDisFac_eq = UnaryOp Log (UnaryOp Log ((Int 1):/((Int 1):-(C pb_tol)))
  :*((Grouping (((C plate_len):/(Int 1000)):*((C plate_width):/(Int 1000)))):^
  ((C sflawParamM) :- (Int 1)):/((C sflawParamK):*
  (Grouping (Grouping ((C mod_elas):*(Int 1000)):*
  (Grouping ((C act_thick):/(Int 1000))):^
  (Int 2))):^(C sflawParamM):*(C loadDF))))

tolStrDisFac :: EqChunk
tolStrDisFac = fromEqn "J_tol" (sdf_tol ^. descr) (sdf_tol ^. symbol) unitless 
  tolStrDisFac_eq
