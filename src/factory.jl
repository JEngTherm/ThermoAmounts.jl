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
"""
function mkNParAbs(
        TY::Pair{Symbol, <:NamedTuple},
        TP::Symbol,
        xp::Bool = true,
        dry::Bool = false,
    )
    @assert(
        any([eval(TP) isa i for i in (DataType, UnionAll)]),
        "Type parent must be DataType or UnionAll. Got $(typeof(string(TP)))."
    )
    stm  = "abstract type $(TY.first){"
    stm *= join(
        [ "$(z[1])<:$(z[2])" for z in zip(keys(TY.second), values(TY.second)) ],
        ", ")
    stm *= "} <: $(TP) end" # TODO: figure out parent's type syntax {A, B, etc...}
    if dry
        println(stm)
    else
        eval(Meta.parse(stm))
    end
end
