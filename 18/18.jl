using DelimitedFiles
using DataStructures

dat = readdlm("18/input.txt", ',', Int)

points = collect(eachrow(dat))

function get_neighbor!(neighbors, p)
    x = [1, 0, 0]
    neighbors[1] = p .+ x
    neighbors[2] = p .- x
    x = [0, 1, 0]
    neighbors[3] = p .+ x
    neighbors[4] = p .- x
    x = [0, 0, 1]
    neighbors[5] = p .+ x
    neighbors[6] = p .- x
    return neighbors
end

# PART 1
surface = 0
ns = Vector{Vector{Int}}(undef, 6)
for p in points
    get_neighbor!(ns, p)
    for n in ns
        if n ∈ points
            surface += 0
        else
            surface += 1
        end
    end
end
@show surface

# PART 2

function find_outside()
    # BFS-type
    q = Queue{Vector{Int}}()
    start = [0,0,0]
    enqueue!(q, start)
    dd = Dict{Vector{Int}, Int}(start => 0)
    while !isempty(q)
        v = dequeue!(q)
        get_neighbor!(ns, v)
        for edge in ns
            alt = dd[v] + 1
            if edge ∉ keys(dd) && edge ∉ points && 0 <= edge[1] <= 21 && 0 <= edge[2] <= 21 && 0 <= edge[3] <= 21
                dd[edge] = alt
                enqueue!(q, edge)
            end
        end
    end
    return keys(dd)
end

outside = find_outside()

lava = Vector{Int}[]
for i = 0:21, j = 0:21, k=0:21
    pt = [i,j,k]
    if pt ∉ outside
        push!(lava, pt)
    end
end

surface = 0
ns = Vector{Vector{Int}}(undef, 6)
for p in lava
    get_neighbor!(ns, p)
    for n in ns
        if n ∈ lava
            surface += 0
        else
            surface += 1
        end
    end
end
@show surface