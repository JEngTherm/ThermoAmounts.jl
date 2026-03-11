"""
`function tyArchy(t::Union{DataType,UnionAll})`\n
Returns a string suitable for documenting the hierarchy of an abstract type.
"""
function tyArchy(t::Union{DataType,UnionAll})
    h = Any[t]; while h[end] != Any; append!(h, [supertype(h[end])]); end
    H = Tuple(string(nameof(i)) for i in h)
    join(H, " <: ")
end

"""
`function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`\n
Declares exactly one new, non-parametric, abstract type `TY <: TP`. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new abstract type is
exported (default `true`).
"""
function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)
    if !(eval(TP) isa DataType)
        error("Type parent must be a DataType. Got $(string(TP)).")
    end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY) <: $(TP) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    @eval begin
        # Abstract type definition
        abstract type $TY <: $TP end
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

# EngTherm root abstract type
mkNonPAbs(:AbstractTherm   , :Any          , "thermodynamic entities"                         )

# BASE branch
mkNonPAbs(  :BASES         , :AbstractTherm, "thermodynamic quantity bases"                   )
mkNonPAbs(    :IntBase     , :BASES        , "intensive bases"                                )
mkNonPAbs(      :MA        , :IntBase      , "the MAss base"                                  )
mkNonPAbs(      :MO        , :IntBase      , "the MOlar base"                                 )
mkNonPAbs(    :ExtBase     , :BASES        , "non-intensive bases"                            )
mkNonPAbs(      :SY        , :ExtBase      , "the SYstem (extensive) base"                    )
mkNonPAbs(      :DT        , :ExtBase      , "the Time Derivative (rate) base"                )

