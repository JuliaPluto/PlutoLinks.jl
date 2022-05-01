### A Pluto.jl notebook ###
# v0.19.3

using Markdown
using InteractiveUtils

# ╔═╡ 5d760db0-8906-11ec-1a77-572cffd0d661
md"""
# `@revise`

The `@revise` macro is useful when developing a package.
Suppose that we're developing a package called `MyPackage`.
Pluto can be set to monitor the package via

```julia
@revise using MyPackage
```

When this package changes, all cells which depend on source code from the package will automatically run again.

Here is an example workflow of editing a package in another editor and testing it reactively in a Pluto notebook:

![Example of using the `@revise` macro](https://user-images.githubusercontent.com/9824244/152143460-798ea60c-a3ec-446f-ba12-c11b513281fe.gif)

In order to include a single file, the [`@ingredients`](./ingredients) macro can be used instead.

### Working on tests

For example, to use this hook to work on tests, the following code can be used.
Note that this code installs [TestEnv](https://github.com/JuliaTesting/TestEnv.jl) in the global Julia environment.

```julia
dir = joinpath(homedir(), "git", "MyPackage.jl")
```

```julia
begin
    using Pkg
    Pkg.add("TestEnv")
    Pkg.activate(dir)
    using TestEnv
    TestEnv.activate()
    Pkg.add("PlutoLinks")
end
```

```julia
using PlutoLinks: @revise
```

```julia
@revise using MyPackage
```

### Acknowledgments

 - The `@revise` macro could not be possible without [Revise.jl](https://github.com/timholy/Revise.jl) (as the name suggests :)).
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
# ╟─5d760db0-8906-11ec-1a77-572cffd0d661
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
