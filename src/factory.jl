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
`function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`

Factory function for a new non-parametric abstract type

## Parameters

- `TY` New abstract type name
- `TP` Parent type name for the new abstract type, so that `TY <: TP`
- `what` Documentation for the new abstract type
- `xp` Whether to export the new abstract type
"""
function mkNonPAbs(
    TY::Symbol,
    TP::Symbol,
    what::AbstractString,
    xp::Bool = true
)
    @assert(eval(TP) isa DataType, "Type parent must be a DataType. Got $(string(TP)).")
    hiStr = tyArchy(eval(TP))
    dcStr = """
    `abstract type $(TY) <: $(TP) end`

    Abstract supertype for $(what).

    $(xp ? "Exported" : "Not exported")

    ## Hierarchy

    `$(TY) <: $(hiStr)`
    """
    return @eval begin
        abstract type $TY <: $TP end
        @doc $dcStr $TY
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
