### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ bdf53020-635d-4cc9-8a0e-a612ca470e85
hook_link(p) = replace(p, ".jl" => ".html");

# ╔═╡ 7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
readme = read(joinpath(@__DIR__, "../README.md"), String) |> Markdown.parse;

# ╔═╡ d974bcaa-935e-4a8c-bfc8-827034e79efe
hook_name(file) = file == "notebook.jl" ? "Other hooks" : "@" * replace(basename(file), ".jl" => "");

# ╔═╡ 11c144eb-60b4-4a64-8077-29e97abedce8
docs = let
	files = map(
		f -> " - [`$(hook_name(f))`](./$(hook_link(f)))",
		filter(
			name -> basename(name) != "index.jl" && endswith(name, ".jl"),
			readdir("./")
		)
	) |> s -> join(s, "\n") |> Markdown.parse

	md"""
	#### Documentation

	 $(files)
	"""
end;

# ╔═╡ 3e715447-312c-4c5f-85a3-96abbb91fc0c
sources = let
	files = map(
		f -> " - [`$(hook_name(f))`](../src/$(hook_link(f)))",
		filter(
			path -> basename(path) != "PlutoLinks.jl" && endswith(path, ".jl"),
			readdir("../src")
		)
	) |> s -> join(s, "\n") |> Markdown.parse

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

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─2175e675-df15-4934-b410-d0def1decf04
# ╟─11c144eb-60b4-4a64-8077-29e97abedce8
# ╟─3e715447-312c-4c5f-85a3-96abbb91fc0c
# ╟─bdf53020-635d-4cc9-8a0e-a612ca470e85
# ╟─7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
# ╟─d974bcaa-935e-4a8c-bfc8-827034e79efe
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
