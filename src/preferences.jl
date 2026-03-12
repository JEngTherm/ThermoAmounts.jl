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

if !(pref_bas["extensive"] in ("SY", "DT"))
    pref_bas["extensive"] = pre_defs["bas"]["ex"]
end

if !(pref_bas["intensive"] in ("MA", "MO"))
    pref_bas["intensive"] = pre_defs["bas"]["in"]
end

@set_preferences!("Bases", pref_bas)

pref_fmt = @load_preference(
    "Formatting", default = Dict(
        "print-pretty" => true,
        "print-precision" => true,
        "significant-digits" => 5,
    )
)

@set_preferences!("Formatting", pref_fmt)
