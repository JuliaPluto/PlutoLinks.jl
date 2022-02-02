# PlutoLinks.jl

This package contains a set of utilities built using [PlutoHooks.jl](https://github.com/JuliaPluto/PlutoHooks.jl).

- `@revise using MyPackage`: Watching the whole package sources and updating the cell when the package definition is updated.
- `@use_task`: Run a process and relay it's output to the rest of your notebook.
- `@use_file`: Watch a file and reload the content when it changes.
- `@ingredients`: Watch a Julia file and automatically run the dependent cells when the code changes.
