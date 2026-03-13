include("factory-abs.jl")

# runic: off
# ThermoAmounts root
mkNonPAbs(:AbstractTherm, :Any              , "thermodynamic entities"          , true)

# BASE branch
mkNonPAbs(  :BASES      , :AbstractTherm    , "thermodynamic quantity bases"    , true)
mkNonPAbs(    :IntBase  , :BASES            , "intensive bases"                 , true)
mkNonPAbs(      :RD     , :IntBase          , "the ReDuced dimensionless base"  , true)
mkNonPAbs(      :MA     , :IntBase          , "the MAss base"                   , true)
mkNonPAbs(      :MO     , :IntBase          , "the MOlar base"                  , true)
mkNonPAbs(    :ExtBase  , :BASES            , "non-intensive bases"             , true)
mkNonPAbs(      :SY     , :ExtBase          , "the SYstem (extensive) base"     , true)
mkNonPAbs(      :DT     , :ExtBase          , "the Time Derivative (rate) base" , true)

# AMOUNTS branch — Pars are (i) precision, and (ii) base
mk2ParAbs(  :AMOUNTS    , :AbstractTherm    , "thermodynamic amounts"           , 0)
mk2ParAbs(    :Property , :AMOUNTS          , "based properties"                , 2)
mk2ParAbs(    :Interact , :AMOUNTS          , "based interactions"              , 2)
mk2ParAbs(    :Unranked , :AMOUNTS          , "based unranked amounts"          , 2)

const PREC = Base.IEEEFloat             # Precision parameter for amount types

const BAS2 = Union{SY, RD}              # Base parameter for amounts having these 2 bases
const BAS3 = Union{SY, RD, DT}          # Base parameter for amounts having these 3 bases
const BAS4 = Union{SY, RD, MA, MO}      # Base parameter for amounts having these 4 bases
const BASE = Union{SY, RD, MA, MO, DT}  # Base parameter for amounts having all bases
# runic: on

export PREC, BAS2, BAS3, BAS4, BASE

export AMOUNTS, Property, Interact, Unranked
