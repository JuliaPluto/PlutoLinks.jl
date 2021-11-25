### A Pluto.jl notebook ###
# v0.17.0

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

# ╔═╡ c82c8aa9-46a9-4110-88af-8638625222e3
import PlutoHooks: @use_ref

# ╔═╡ bc0e4219-a40b-46f5-adb2-f164d8a9bbdb
import PlutoHooks: @use_memo

# ╔═╡ 274c2be6-6075-45cf-b28a-862c8bf64bd4
md"""
### Util functions
---
"""

# ╔═╡ 8a6c8e24-1a9a-43f0-93ea-f58042251ba0
function parse_cell_id(filename::String)
	if !occursin("#==#", filename)
		throw("not pluto filename")
	end
	split(filename, "#==#") |> last |> UUID
end

# ╔═╡ 1df0a586-3692-11ec-0171-0b48a4a1c4bd
import PlutoHooks: @use_state

# ╔═╡ 51371f3c-472e-4002-bae4-c20b8364af32
"""
Turns different way of expressing code to an anonymous arrow function definition.
"""
function as_arrow(ex::Expr)
	if Meta.isexpr(ex, :(->))
		ex
	elseif Meta.isexpr(ex, :do)
		Expr(:(->), ex.args...)
	elseif Meta.isexpr(ex, :block)
		Expr(:(->), Expr(:tuple), ex)
	elseif Meta.isexpr(ex, :function)
		root = ex.args[1]
		Expr(:(->), root.head == :call ? Expr(:tuple, root.args[2:end]...) : root, ex.args[2])
	else
		throw("Can't transform expression into an arrow function")
	end
end

# ╔═╡ 89b3f807-2e24-4454-8f4c-b2a98aee571e
import PlutoHooks: @use_effect

# ╔═╡ 6f38af33-9cae-4e2b-8431-8ea3185e109a
as_arrow(:(function(x, y) x+y end))

# ╔═╡ 15498bfa-a8f3-4e7d-aa2e-4daf00be1ef5
as_arrow(:(function f(x, y) x+y end))

# ╔═╡ b889049a-ab95-454d-8297-b484ea52f4f5
as_arrow(:(function f() x+y end))

# ╔═╡ fe191402-fdcf-4e3e-993e-43991576f33b
macro current_cell_id()
	parse_cell_id(string(__source__.file))
end

# ╔═╡ 80ed971f-59ba-42ab-ad61-e18026ee68d4
# let
# 	x = @use_ref(2)
# 	if x[] == 2
# 		@current_cell_id() |> PlutoRunner._self_run
# 	end
# 	x[] += 1
# 	sleep(.8)
	
# 	x[]
# end

# ╔═╡ e6860783-0c6c-4095-8b9b-e0f506f32fc1
# begin
# 	file_content, set_file_content = @use_state("")

# 	@use_effect([filename]) do
# 		task = Task() do
# 			@info "restarting" filename
# 			read(filename, String) |> set_file_content

# 			try
# 				while true
# 					watch_file(filename)
# 					@info "update"
# 					set_file_content(read(filename, String))
# 				end
# 			catch e
# 				@error "filewatching failed" err=e
# 				throw(e)
# 			end
# 		end |> schedule

# 		() -> begin
# 			if !istaskdone(task) && !istaskfailed(task)
# 				Base.schedule(task, InterruptException(), error=true)
# 			elseif istaskfailed(task)
# 				@warn "task is failed" res=fetch(task)
# 			end
# 		end
# 	end

# 	file_content |> Text
# end

# ╔═╡ 0b60be66-b671-41aa-9b18-b43f43420aaf
macro caller_cell_id()
	esc(quote
        parse_cell_id(string(__source__.file::Symbol))
    end)
end

# ╔═╡ 9ec99592-955a-41bd-935a-b34f37bb5977
"""
Wraps a `Task` with the current cell. When the cell state is reset, sends an `InterruptException` to the underlying `Task`.

```julia
@background begin
	while true
		sleep(2.)
		@info "this is updating"
	end
end
```

It can be combined with `@use_state` for background updating of values.
"""
macro background(f, cell_id=nothing)
	cell_id = cell_id !== nothing ? cell_id : @caller_cell_id()

	quote
		@use_effect([], $cell_id) do
			task = Task() do
				try
					$(esc(as_arrow(f)))()
				catch e
					e isa InterruptException && return
					@error "task failed" err=e
				end
			end |> schedule
	
			() -> begin
				if !istaskdone(task) && !istaskfailed(task)
					Base.schedule(task, InterruptException(), error=true)
				elseif istaskfailed(task)
					res = fetch(task)
					res isa InterruptException && return
					@warn "task is failed" res
				end
			end
		end
	end
end

# ╔═╡ 10f015c0-84b1-43b6-b2c1-83819740af44
# @pluto_async begin
# 	while true 
# 		sleep(2.)
# 		@info "heyeyeyry"
# 	end
# end

# ╔═╡ 461231e8-4958-46b9-88cb-538f9151a4b0
macro file_watching(filename)
	cell_id = @caller_cell_id()
	filename = esc(filename)

	quote
		file_content, set_file_content = @use_state(read($filename, String), $cell_id)

		@background($cell_id) do
			while true
				watch_file($filename)
				set_file_content(read($filename, String))
			end
		end
	
		file_content
	end
end

# ╔═╡ dfa5f319-7948-47a4-85a6-e6e24b749b29
# filename = "~/Projects/myfile.csv" |> expanduser

# ╔═╡ 0bce9856-6916-4d54-9534-aaddcd8126bc
# (@file_watching(filename) |> Text), @current_cell_id()

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
macro ingredients(filename)
	cell_id = @caller_cell_id()
	filename = esc(filename)

	quote
		mod, set_mod = @use_state(ingredients($filename), $cell_id)

		@background($cell_id) do
			while true
				watch_file($filename)
				set_mod(ingredients($filename))
			end
		end

		mod
	end
end

# ╔═╡ ff764d7d-2c07-44bd-a675-89c9e2b00151
# notebook = @ingredients("/home/paul/Projects/cookie.jl")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
FileWatching = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[Random]]
deps = ["Serialization"]
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
# ╠═c82c8aa9-46a9-4110-88af-8638625222e3
# ╠═1df0a586-3692-11ec-0171-0b48a4a1c4bd
# ╠═89b3f807-2e24-4454-8f4c-b2a98aee571e
# ╠═bc0e4219-a40b-46f5-adb2-f164d8a9bbdb
# ╟─274c2be6-6075-45cf-b28a-862c8bf64bd4
# ╠═49cb409b-e564-47aa-9dae-9bc5bffa991d
# ╠═8a6c8e24-1a9a-43f0-93ea-f58042251ba0
# ╠═51371f3c-472e-4002-bae4-c20b8364af32
# ╠═6f38af33-9cae-4e2b-8431-8ea3185e109a
# ╠═15498bfa-a8f3-4e7d-aa2e-4daf00be1ef5
# ╠═b889049a-ab95-454d-8297-b484ea52f4f5
# ╠═fe191402-fdcf-4e3e-993e-43991576f33b
# ╠═80ed971f-59ba-42ab-ad61-e18026ee68d4
# ╠═b0350bd0-5dd2-4c73-b301-f076123144c2
# ╠═e6860783-0c6c-4095-8b9b-e0f506f32fc1
# ╠═0b60be66-b671-41aa-9b18-b43f43420aaf
# ╠═9ec99592-955a-41bd-935a-b34f37bb5977
# ╠═10f015c0-84b1-43b6-b2c1-83819740af44
# ╠═461231e8-4958-46b9-88cb-538f9151a4b0
# ╠═dfa5f319-7948-47a4-85a6-e6e24b749b29
# ╠═0bce9856-6916-4d54-9534-aaddcd8126bc
# ╠═480dd46c-cc31-46b5-bc2d-2e1680d5c682
# ╠═d84f47ba-7c18-4d6c-952c-c9a5748a51f8
# ╠═ff764d7d-2c07-44bd-a675-89c9e2b00151
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
