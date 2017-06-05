module Drasil.SWHS.Concepts where

import Language.Drasil
import Data.Drasil.Concepts.Software (program)
import Control.Lens ((^.))

---Acronyms---
phsChgMtrl,rightSide,progName :: CINP

phsChgMtrl  = commonINP "phsChgMtrl" (nounPhrase "phase change material" "phase change materials")           "PCM"
rightSide   = commonINP "rightSide"  (nounPhrase "right hand side" "right hand sides")                       "RHS" 
progName    = commonINP "progName"   (nounPhrase "solar water heating system" "solar water heating systems") "SWHS" 

swhsFull :: NPNC
swhsFull    = npnc "swhsFull" (progName `with'` phsChgMtrl)
-- I want to include SI as an acronym, but I can't find a way for the 
-- description to have accents when using dcc.

---ConceptChunks---

charging, coil, discharging, gauss_div,
  perfect_insul, phase_change_material, swhs_pcm, tank,
  tank_pcm, transient, water, sWHT :: ConceptChunk
swhsProg :: NPNC

  
charging = dcc "charging" (nounPhraseSP "charging") "charging of the tank"

coil = dcc "coil" (cn' "heating coil")
  "Coil in tank that heats by absorbing solar energy"

discharging = dcc "discharging" (nounPhraseSP "discharging") 
  "discharging of the tank"

gauss_div = dcc "gauss_div" (nounPhraseSP "gauss's divergence theorem")
  "A result that relates the flow of a vector field through a surface to the behavior of the vector field inside the surface"
--TODO: Physical property.

perfect_insul = dcc "perfect_insul" (nounPhraseSP "perfectly insulated")
  "Describes the property of a material not allowing heat transfer through its boundaries" 

phase_change_material = dcc "pcm" (phsChgMtrl ^. term)
      ("A substance that uses phase changes (such as melting) to absorb or " ++
      "release large amounts of heat at a constant temperature")
      
--FIXME: Temporarily have to manually create the compound phrase, because it
--uses acronym and a sentence.

--Didn't work
--swhsProg = npnc' "swhsProg" (nounPhrase''
--  (compoundNPNC'' fterm short phrase progName (program ^. term))
--  (fterm short progName +:+ (phrase $ program ^. term))
--  CapFirst CapWords) "SWHS"

swhsProg = npnc' "swhsProg" (nounPhrase'' (fterm fterm short progName +:+ 
  (phrase $ program ^. term)) (fterm short progName +:+ (phrase $ program ^. term))
  CapFirst CapWords) "SWHS"

--Nounphrase'' hack to get nounPhraseSP words to accept nounPhrases instead of strings
swhs_pcm = dcc "swhs_pcm" (nounPhrase'' 
  ((plural $ progName ^. term) +:+ S "incorporating" +:+ fterm short phsChgMtrl)
  ((plural $ progName ^. term) +:+ S "incorporating" +:+ fterm short phsChgMtrl)
  CapFirst CapWords)
  "Solar water heating systems incorporating phase change material"

tank = dcc "tank" (cn' "tank") "Enclosure containing some kind of substance"
sWHT = dcc "sWHT" (cn' "solar water heating tank") "Solar water heating tank"

tank_pcm = dcc "tank_pcm" (nounPhrase''
  ((phrase $ sWHT ^. term) +:+ S "incorporating" +:+ fterm short phsChgMtrl)
  ((phrase $ sWHT ^. term) +:+ S "incorporating" +:+ fterm short phsChgMtrl)
  CapFirst CapWords)
  "Solar water heating tank incorporating phase change material"

transient = dcc "transient" (nounPhraseSP "transient") "Changing with time"

water = dcc "water" (cn' "water") "The liquid with which the tank is filled"
