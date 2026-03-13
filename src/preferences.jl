using InteractiveUtils

pre_defs = Dict(
    "bas" => Dict(
        "ex" => "SY",
        "in" => "MA",
    ),
    "fmt" => Dict(
        "pp" => true,
        "pr" => true,
        "sd" => 5,
    ),
)

pref_bas = @load_preference("Bases")
@show (16, pref_bas)

if !(pref_bas isa Dict)
    pref_bas = Dict(
        "extensive" => pre_defs["bas"]["ex"],
        "intensive" => pre_defs["bas"]["in"],
    )
else
    if !("extensive" in keys(pref_bas)) || !(pref_bas["extensive"] in ("SY", "DT"))
        pref_bas["extensive"] = pre_defs["bas"]["ex"]
    end
    if !("intensive" in keys(pref_bas)) || !(pref_bas["intensive"] in ("MA", "MO"))
        pref_bas["intensive"] = pre_defs["bas"]["in"]
    end
end

pref_fmt = @load_preference("Formatting")

if !(pref_fmt isa Dict)
    pref_fmt = Dict(
        "print-pretty" => pre_defs["fmt"]["pp"],
        "print-precision" => pre_defs["fmt"]["pr"],
        "significant-digits" => pre_defs["fmt"]["sd"],
    )
else
    if !("print-pretty" in keys(pref_fmt)) || !(pref_fmt["print-pretty"] isa Bool)
        pref_fmt["print-pretty"] = pre_defs["fmt"]["pp"]
    end
    if !("print-precision" in keys(pref_fmt)) || !(pref_fmt["print-precision"] isa Bool)
        pref_fmt["print-precision"] = pre_defs["fmt"]["pr"]
    end
    if !("significant-digits" in keys(pref_fmt)) || begin
            !(pref_fmt["significant-digits"] isa Int) &&
                (pref_fmt["significant-digits"] <= 0)
        end
        pref_fmt["significant-digits"] = pre_defs["fmt"]["sd"]
    end
end

@set_preferences!("Bases" => pref_bas)
@set_preferences!("Formatting" => pref_fmt)

"""
`DEF = Dict(...)`\n
The internal representation of user-facing package preferences\n
Exported.
"""
DEF = Dict(
    # getglobal(Module, Symbol) hack to instantiate the abstract type from Symbol from String
    :ib => getglobal(ThermoAmounts, Symbol(pref_bas["intensive"])),
    :eb => getglobal(ThermoAmounts, Symbol(pref_bas["extensive"])),
    :pp => pref_fmt["print-pretty"],
    :pr => pref_fmt["print-precision"],
    :sd => pref_fmt["significant-digits"],
)

export DEF
