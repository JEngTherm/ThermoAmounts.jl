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
mkNonPAbs(:AbstractTherm, :Any, "thermodynamic entities")

# BASE branch
mkNonPAbs(:BASES, :AbstractTherm, "thermodynamic quantity bases")
mkNonPAbs(:IntBase, :BASES, "intensive bases")
mkNonPAbs(:MA, :IntBase, "the MAss base")
mkNonPAbs(:MO, :IntBase, "the MOlar base")
mkNonPAbs(:ExtBase, :BASES, "non-intensive bases")
mkNonPAbs(:SY, :ExtBase, "the SYstem (extensive) base")
mkNonPAbs(:DT, :ExtBase, "the Time Derivative (rate) base")

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
- `TY{PTYP} <: TP{PTYP}` for `pp >= 1` (default);
- `TY{PTYP<:PREC} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=1, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp>=1 ? "{PTYP}" : ""
    dcStr = """
    `abstract type $(TY){PTYP<:PREC} <: $(TP)$(ppStr) end`\n
    Abstract supertype for $(what).\n
    $(xp ? "Exported\n" : "Not exported\n")
    ## Hierarchy\n
    `$(TY) <: $(hiStr)`
    """
    if      pp>=1   @eval (abstract type $TY{PTYP} <: $TP{PTYP} end)
    elseif  pp<=0   @eval (abstract type $TY{PTYP<:PREC} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end



