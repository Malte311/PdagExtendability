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
		"Introduction" => "index.md",
		"API Reference" => "api_reference.md",
	],
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)