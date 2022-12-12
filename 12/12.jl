using DataStructures

function parseinput(fname)
    lines = readlines(fname)
    for line in lines
        if (startswith(line, ""))
        end
    end
    return 
end

function neighbors(A, index)
    n = CartesianIndex[]

    newI = CartesianIndex(1,0)
    if index.I[1] > 1
        if (A[index - CartesianIndex(1,0)] <= (A[index] + 1))
            push!(n, index - newI)
        end
    end
    if index.I[1] < size(A, 1)
        if (A[index + CartesianIndex(1,0)] <= (A[index] + 1))
            push!(n, index + newI)
        end
    end
    newI = CartesianIndex(0,1)
    if index.I[2] > 1
        if (A[index - CartesianIndex(0,1)] <= (A[index] + 1))
            push!(n, index - newI)
        end
    end
    if index.I[2] < size(A, 2)
        if (A[index + CartesianIndex(0,1)] <= (A[index] + 1))
            push!(n, index + newI)
        end
    end
    return n
end

lines = readlines("12/input.txt")
A = Matrix{Char}(undef, length(lines), length(lines[1]))
for (j, line) in enumerate(lines), (i, c) in enumerate(line)
    A[j,i] = c
end
start = findfirst(==('S'), A)
A[start] = 'a'
endnode = findfirst(==('E'), A)
A[endnode] = 'z'
 
starting_nodes = findall(==('a'), A)
paths = Int[]
for start in starting_nodes
    dist = Dict{CartesianIndex, Int}()
    dist[start] = 0

    qu = PriorityQueue{CartesianIndex, Int}()
    prev = Dict{CartesianIndex, CartesianIndex}()
    qu[start] = 0
    while !isempty(qu)
        u = dequeue!(qu)

        if (u == endnode) 
            push!(paths, dist[u])
            @show dist[u]
            break
        end

        for n in neighbors(A, u)
            if n ∈ keys(dist)
                alt = dist[u] + 1
                if alt < dist[n]
                    dist[n] = alt
                    prev[n] = u
                    qu[n] = dist[n]
                end
            else
                dist[n] = dist[u] + 1
                prev[n] = u
                qu[n] = dist[n]
            end
        end
    end
end

tree = CartesianIndex[]
u = endnode
while u != start
    u = prev[u]
    pushfirst!(tree, u)
end
tree