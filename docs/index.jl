### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
readme = read(joinpath(@__DIR__, "../README.md"), String) |> Markdown.parse;

# ╔═╡ 02be7952-8906-11ec-171c-4d373e8cbbbb
md"""
$(readme)

#### Documentation

 - [`@revise`](./revise.jl)

#### Source code

 - [`@revise`](../src/revise.jl)
 - [Other hooks](../src/notebook.jl)
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
# ╟─02be7952-8906-11ec-171c-4d373e8cbbbb
# ╟─7c852ed0-36b8-43ea-8ee8-c4bd45e9c8a9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
