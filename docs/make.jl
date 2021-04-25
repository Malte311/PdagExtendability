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
		"Extendability" => "extendability.md",
		"Recognition" => "recognition.md",
		"Maximum Orientation" => "maximum_orientation.md",
		"Utilities" => "utils.md"
	],
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)