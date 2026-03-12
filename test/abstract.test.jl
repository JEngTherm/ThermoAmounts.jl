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
