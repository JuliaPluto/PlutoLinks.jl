module PlutoLinks

using Requires

include("./notebook.jl")

function __init__()
    @require Revise="295af30f-e4ad-537b-8983-00126c2a3abe" include("./revise.jl")
end

export @use_file, @use_task, @ingredients, @revise

end
