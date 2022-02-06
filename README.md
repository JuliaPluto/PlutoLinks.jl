# PlutoLinks.jl

This package contains a set of utilities built using [PlutoHooks.jl](https://github.com/JuliaPluto/PlutoHooks.jl).

- `@revise`: Watch a local package and update the cell when the package source changes.
   See below for more information.
- `@use_task`: Run a process and relay it's output to the rest of your notebook.
- `@use_file`: Watch a file and reload the content when it changes.
- `@ingredients`: Watch a Julia file and automatically run the dependent cells when the code changes.

## `@revise`

The `@revise` macro is useful when developing a package.
Suppose that we're developing a package called `MyPackage`.
Pluto can be set to monitor the package via

```julia
@revise using MyPackage
```

When this package changes, all cells which depend on source code from the package will automatically run again.

For example, to use this to work on tests, the following code can be used.
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
