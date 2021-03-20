using Documenter

push!(LOAD_PATH, "../src/")

makedocs(
	sitename="PDAG-Extendability",
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true"
	)
)