### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
readme = read(joinpath(@__DIR__, "../README.md"), String) |> Markdown.parse;

# ╔═╡ d974bcaa-935e-4a8c-bfc8-827034e79efe
hook_name(file) = file == "notebook.jl" ? "Other hooks" : "@" * replace(basename(file), ".jl" => "");

# ╔═╡ 11c144eb-60b4-4a64-8077-29e97abedce8
docs = let
	files = map(f -> " - [`$(hook_name(f))`](./$f)", filter(!=("index.jl") ∘ basename, readdir("./"))) |> s -> join(s, "\n") |> Markdown.parse

	md"""
	#### Documentation

	 $(files)
	"""
end;

# ╔═╡ 3e715447-312c-4c5f-85a3-96abbb91fc0c
sources = let
	files = map(f -> " - [`$(hook_name(f))`](./$f)",
		filter(!=("PlutoLinks.jl") ∘ basename, readdir("../src"))) |> s -> join(s, "\n") |> Markdown.parse

	md"""
	#### Source code
	
	$(files)
	"""
end;

# ╔═╡ 2175e675-df15-4934-b410-d0def1decf04
md"""
$(readme)
$(docs)
$(sources)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─2175e675-df15-4934-b410-d0def1decf04
# ╟─11c144eb-60b4-4a64-8077-29e97abedce8
# ╟─3e715447-312c-4c5f-85a3-96abbb91fc0c
# ╟─7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
# ╟─d974bcaa-935e-4a8c-bfc8-827034e79efe
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
