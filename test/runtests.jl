using Test, Documenter, ThermoAmounts

include("abstract.test.jl")

# DocTests
@testset "DocTests for ThermoAmounts                                              " begin
    doctest(ThermoAmounts; manual = false)
end
