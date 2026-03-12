"""
`function tyArchy(t::Union{DataType,UnionAll})`\n
Returns a string suitable for documenting the hierarchy of an abstract type.
"""
function tyArchy(t::Union{DataType, UnionAll})
    h = Any[t]; while h[end] != Any
        append!(h, [supertype(h[end])])
    end
    H = Tuple(string(nameof(i)) for i in h)
    return join(H, " <: ")
end

"""
`function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`\n
Declares exactly one new, non-parametric, abstract type `TY <: TP`. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new abstract type is
exported (default `true`).
"""
function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool = true)
    if !(eval(TP) isa DataType)
        error("Type parent must be a DataType. Got $(string(TP)).")
    end
    hiStr = tyArchy(eval(TP))
    dcStr = """
    `abstract type $(TY) <: $(TP) end`\n
    Abstract supertype for $(what).\n
    $(xp ? "Exported\n" : "Not exported\n")
    ## Hierarchy\n
    `$(TY) <: $(hiStr)`
    """
    return @eval begin
        # Abstract type definition
        abstract type $TY <: $TP end
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp)
            export $TY
        end
    end
end

# ThermoAmounts root abstract type
# runic: off
mkNonPAbs(:AbstractTherm, :Any             , "thermodynamic entities"          )
# runic: on

# BASE branch
mkNonPAbs(:BASES, :AbstractTherm, "thermodynamic quantity bases")
mkNonPAbs(:IntBase, :BASES, "intensive bases")
mkNonPAbs(:MA, :IntBase, "the MAss base")
mkNonPAbs(:MO, :IntBase, "the MOlar base")
mkNonPAbs(:ExtBase, :BASES, "non-intensive bases")
mkNonPAbs(:SY, :ExtBase, "the SYstem (extensive) base")
mkNonPAbs(:DT, :ExtBase, "the Time Derivative (rate) base")
# runic: on

"""
`const PREC = Base.IEEEFloat`\n
Concrete precision type union for parametric abstract types.\n
Exported.
"""
const PREC = Base.IEEEFloat

"""
`const BASE = Union{MA, MO, SY, DT}`\n
Concrete base type union for parametric abstract types.\n
Exported.
"""
const BASE = Union{MA, MO, SY, DT}

export PREC, BASE

"""
`function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=1,
xp::Bool=true)`\n
Declares a new, 1-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{_P} <: TP{_P}` for `pp >= 1` (default);
- `TY{_P<:PREC} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk1ParAbs(
        TY::Symbol, TP::Symbol, what::AbstractString,
        pp::Integer = 1, xp::Bool = true
    )
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp >= 1 ? "{_P}" : ""
    dcStr = """
    `abstract type $(TY){_P<:PREC} <: $(TP)$(ppStr) end`\n
    Abstract supertype for $(what).\n
    $(xp ? "Exported\n" : "Not exported\n")
    ## Hierarchy\n
    `$(TY) <: $(hiStr)`
    """
    if pp >= 1
        @eval (abstract type $TY{_P} <: $TP{_P} end)
    elseif pp <= 0
        @eval (abstract type $TY{_P <: PREC} <: $TP end)
    end
    return @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp)
            export $TY
        end
    end
end

"""
`function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=2,
xp::Bool=true)`\n
Declares a new, 2-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{_P,_B} <: TP{_P,_B}` for `pp >= 2` (default);
- `TY{_P,_B<:BASE} <: TP{_P}` for `pp = 1`;
- `TY{_P<:PREC,_B<:BASE} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk2ParAbs(
        TY::Symbol, TP::Symbol, what::AbstractString,
        pp::Integer = 2, xp::Bool = true
    )
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp >= 2 ? "{_P, _B}" : pp == 1 ? "{_P}" : ""
    dcStr = """
    `abstract type $(TY){_P<:PREC, _B<:BASE} <: $(TP)$(ppStr) end`\n
    Abstract supertype for $(what).\n
    $(xp ? "Exported\n" : "Not exported\n")
    ## Hierarchy\n
    `$(TY) <: $(hiStr)`
    """
    if pp >= 2
        @eval (abstract type $TY{_P, _B} <: $TP{_P, _B} end)
    elseif pp == 1
        @eval (abstract type $TY{_P, _B <: BASE} <: $TP{_P} end)
    elseif pp <= 0
        @eval (abstract type $TY{_P <: PREC, _B <: BASE} <: $TP end)
    end
    return @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp)
            export $TY
        end
    end
end

# AMOUNTS branch — Pars are (i) precision, and (ii) base
# runic: off
mk1ParAbs(  :AMOUNTS       , :AbstractTherm, "thermodynamic amounts"                       , 0)
mk1ParAbs(    :WholeAmt    , :AMOUNTS      , "whole, unbased amounts of fixed units"       , 1)
mk1ParAbs(      :WProperty , :WholeAmt     , "whole, unbased properties"                   , 1)
mk1ParAbs(      :WInteract , :WholeAmt     , "whole, unbased interactions"                 , 1)
mk1ParAbs(      :WUnranked , :WholeAmt     , "whole, unbased unranked amounts"             , 1)
mk2ParAbs(    :BasedAmt    , :AMOUNTS      , "based amounts of fixed units"                , 1)
mk2ParAbs(      :BProperty , :BasedAmt     , "based properties"                            , 2)
mk2ParAbs(      :BInteract , :BasedAmt     , "based interactions"                          , 2)
mk2ParAbs(      :BUnranked , :BasedAmt     , "based unranked amounts"                      , 2)
mk1ParAbs(    :GenerAmt    , :AMOUNTS      , "generic, arbitrary unit amounts"             , 1)
# runic: on

Property{_P} = Union{WProperty{_P}, BProperty{_P, _B} where {_B}} where {_P}
Interact{_P} = Union{WInteract{_P}, BInteract{_P, _B} where {_B}} where {_P}
Unranked{_P} = Union{WUnranked{_P}, BUnranked{_P, _B} where {_B}} where {_P}

export Property, Interact, Unranked
