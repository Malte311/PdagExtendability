push!(LOAD_PATH, "../src/")

using Documenter, PdagExtendability

makedocs(
	source = "src",
	build = "build",
	clean = true,
	doctest = true,
	modules = Module[PdagExtendability],
	repo = "",
	highlightsig = true,
	sitename = "PdagExtendability",
	expandfirst = [],
	pages = [
		"Overview" => "index.md",
		"Getting Started" => "getting_started.md",
		"Extension Problem" => "extendability.md",
		"Enumeration Problem" => "enumeration.md",
		"Utilities" => "utils.md"
	],
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)