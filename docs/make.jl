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
		"PdagExtendability.jl" => "index.md",
		"Table of Contents" => "toc.md",
	],
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)