### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 49cb409b-e564-47aa-9dae-9bc5bffa991d
using UUIDs

# ╔═╡ b0350bd0-5dd2-4c73-b301-f076123144c2
using FileWatching

# ╔═╡ 729ae3bb-79c2-4fcd-8645-7e0071365537
md"""
# PlutoLinks.jl

Yayyyyyy
"""

# ╔═╡ 968f741b-e70f-4bc1-94b7-ebe8eff868ab
import PlutoHooks: @use_deps

# ╔═╡ c82c8aa9-46a9-4110-88af-8638625222e3
import PlutoHooks: @use_ref

# ╔═╡ 1df0a586-3692-11ec-0171-0b48a4a1c4bd
import PlutoHooks: @use_state

# ╔═╡ 89b3f807-2e24-4454-8f4c-b2a98aee571e
import PlutoHooks: @use_effect

# ╔═╡ bc0e4219-a40b-46f5-adb2-f164d8a9bbdb
import PlutoHooks: @use_memo

# ╔═╡ 9ec99592-955a-41bd-935a-b34f37bb5977
"""
Wraps a `Task` with the current cell. When the cell state is reset, sends an `InterruptException` to the underlying `Task`.
```julia
@use_task([]) do
	while true
		sleep(2.)
		@info "this is updating"
	end
end
```
It can be combined with `@use_state` for background updating of values.

I'm still wondering if it is best to have `deps=nothing` as a default, or have `deps=[]` or maybe even require deps explicitly so people are forced to know what they are doing.
"""
macro use_task(f, deps)
	quote
		try
			@use_deps($(esc(deps))) do
				_, refresh = @use_state(nothing)
				task_ref = @use_ref(Task($(esc(f))))
		
				@use_effect([]) do
					task = task_ref[]
	
					schedule(Task() do
						try
							fetch(task)
						finally
							refresh(nothing)
						end
					end)
			
					schedule(task)
			
					return function()
						if !istaskdone(task)
							try
								Base.schedule(task, InterruptException(), error=true)
							catch error
								nothing
							end
						end
					end
				end
		
				task_ref[]
			end
		catch e
			@warn "Got an error in use_task" e
		end
	end
end

# ╔═╡ 74b8a338-9eff-453c-9013-c11d5b57833b
"""
Watches a file and returns its content.

```julia
file_content = @use_file("my_dataset.csv") # file_content will contains the content of my_dataset.csv as a string
```

"""
macro use_file(filename)
	quote
		filename = $(esc(filename))
		update_time = @use_file_change(filename)
		@use_memo([update_time]) do
			read(filename, String)
		end
	end
end

# ╔═╡ 2ae53102-c6f8-4f84-8020-e3b28425240f
macro use_file_change(filename)
	quote
		filename = $(esc(filename))

		@use_deps([filename]) do
			last_update_time, set_last_update_time = @use_state(time())
	
			@use_task([]) do
				while true
					watch_file(filename)
					set_last_update_time(time())
				end
			end
		
			last_update_time
		end
	end
end

# ╔═╡ 480dd46c-cc31-46b5-bc2d-2e1680d5c682
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ d84f47ba-7c18-4d6c-952c-c9a5748a51f8
"""
Watch a Julia source file and loads its content as a module. The loaded module is then reloaded automatically whenever the file changes.

```julia
MyModule = @ingredients("my_exported_function.jl")
```
"""
macro ingredients(filename)
	quote
		let
			filename = $(esc(filename))
			update_time = @use_file_change(filename)
			@use_memo([update_time]) do
				ingredients(filename)
			end
		end
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
FileWatching = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
PlutoHooks = "0ff47ea0-7a50-410d-8455-4348d5de0774"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
PlutoHooks = "~0.0.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[PlutoHooks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "f297787f7d7507dada25f6769fe3f08f6b9b8b12"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.3"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
"""

# ╔═╡ Cell order:
# ╟─729ae3bb-79c2-4fcd-8645-7e0071365537
# ╠═968f741b-e70f-4bc1-94b7-ebe8eff868ab
# ╠═c82c8aa9-46a9-4110-88af-8638625222e3
# ╠═1df0a586-3692-11ec-0171-0b48a4a1c4bd
# ╠═89b3f807-2e24-4454-8f4c-b2a98aee571e
# ╠═bc0e4219-a40b-46f5-adb2-f164d8a9bbdb
# ╠═49cb409b-e564-47aa-9dae-9bc5bffa991d
# ╠═b0350bd0-5dd2-4c73-b301-f076123144c2
# ╠═9ec99592-955a-41bd-935a-b34f37bb5977
# ╠═74b8a338-9eff-453c-9013-c11d5b57833b
# ╠═2ae53102-c6f8-4f84-8020-e3b28425240f
# ╠═480dd46c-cc31-46b5-bc2d-2e1680d5c682
# ╠═d84f47ba-7c18-4d6c-952c-c9a5748a51f8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
