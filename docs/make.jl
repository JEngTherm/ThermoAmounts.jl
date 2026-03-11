using ThermoAmounts
using Documenter

DocMeta.setdocmeta!(ThermoAmounts, :DocTestSetup, :(using ThermoAmounts); recursive=true)

makedocs(;
    modules=[ThermoAmounts],
    authors="C. Naaktgeboren",
    sitename="ThermoAmounts.jl",
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
