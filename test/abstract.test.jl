using InteractiveUtils

function union2vec(theU::Union)
    ret = DataType[]
    while theU isa Union
        push!(ret, theU.a)
        theU = theU.b
    end
    push!(ret, theU)
    return ret
end

@testset "abstract.test.jl: PREC, and BASE type Union tests                       " begin
    # All PREC members must be IEEE floats:
    for __t in union2vec(ThermoAmounts.PREC)
        @test __t <: Base.IEEEFloat
    end
    # BASE must contain all ThermBase subtypes:
    @test Set(union2vec(ThermoAmounts.BASE)) ==
        Set(vcat([ subtypes(i) for i in subtypes(BASES) ]...))
end

#runic: off
@testset "abstract.test.jl: ThermoAmounts type tree tests                         " begin
    # All types and parents
    for (__t, __p) in [
            # Top-Level
            (:AbstractTherm, :Any),
            # BASES branch
            (:BASES, :AbstractTherm),
            (:IntBase, :BASES),
            (:MA, :IntBase),
            (:MO, :IntBase),
            (:ExtBase, :BASES),
            (:SY, :ExtBase),
            (:DT, :ExtBase),
            # AMOUNTS branch
            (:AMOUNTS, :AbstractTherm),
            (:WholeAmt, :AMOUNTS),
            (:WProperty, :WholeAmt),
            (:WInteract, :WholeAmt),
            (:WUnranked, :WholeAmt),
            (:BasedAmt, :AMOUNTS),
            (:BProperty, :BasedAmt),
            (:BInteract, :BasedAmt),
            (:BUnranked, :BasedAmt),
            (:GenerAmt, :AMOUNTS),
        ]
        @test typeof(eval(__t)) in (DataType, UnionAll)
        @test typeof(eval(__p)) in (DataType, UnionAll)
        __S = supertype(eval(__t))
        while typeof(__S) == UnionAll
            __S = __S.body
        end
        @test eval(__p) === __S.name.wrapper
    end
end
#runic: on
