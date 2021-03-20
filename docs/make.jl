using Documenter

push!(LOAD_PATH, "../src/")

makedocs(
	sitename="PdagExtendability",
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)