# PlutoLinks.jl

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapluto.github.io/PlutoLinks.jl/docs/index.html)

This package contains a set of utilities built using [PlutoHooks.jl](https://github.com/JuliaPluto/PlutoHooks.jl).

- `@revise`: Watch a local package and update the cell when the package source changes.
   See below for more information.
- `@use_task`: Run a process and relay it's output to the rest of your notebook.
- `@use_file`: Watch a file and reload the content when it changes.
- `@ingredients`: Watch a Julia file and automatically run the dependent cells when the code changes.
- `@use_debounce`: Wait for a variable value to stabilize before updating its output.
- `@use_process` and `@use_process_output`: to run a process asynchronously and restart it when the calling cell is explicitely run.
