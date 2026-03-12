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

pref_bas = @load_preference(
    "Bases", default = Dict(
        "extensive" => pre_defs["bas"]["ex"],
        "intensive" => pre_defs["bas"]["in"],
    )
)

if !(pref_bas["extensive"] in (repr(i) for i in subtypes(ExtBase)))
    pref_bas["extensive"] = pre_defs["bas"]["ex"]
end

if !(pref_bas["intensive"] in (repr(i) for i in subtypes(IntBase)))
    pref_bas["intensive"] = pre_defs["bas"]["in"]
end

@set_preferences!("Bases" => pref_bas)

pref_fmt = @load_preference(
    "Formatting", default = Dict(
        "print-pretty" => pre_defs["fmt"]["pp"],
        "print-precision" => pre_defs["fmt"]["pr"],
        "significant-digits" => pre_defs["fmt"]["sd"],
    )
)

if !(pref_fmt["print-pretty"] isa Bool)
    pref_fmt["print-pretty"] = pre_defs["fmt"]["pp"]
end

if !(pref_fmt["print-precision"] isa Bool)
    pref_fmt["print-precision"] = pre_defs["fmt"]["pr"]
end

if !(pref_fmt["significant-digits"] isa Int) && (pref_fmt["significant-digits"] <= 0)
    pref_fmt["significant-digits"] = pre_defs["fmt"]["sd"]
end

@set_preferences!("Formatting" => pref_fmt)

"""
`DEF = Dict(...)`\n
The internal representation of user-facing package preferences\n
Exported.
"""
DEF = Dict(
    :ib => pref_bas["intensive"],
    :eb => pref_bas["extensive"],
    :pp => pref_fmt["print-pretty"],
    :pr => pref_fmt["print-precision"],
    :sd => pref_fmt["significant-digits"],
)

export DEF
