A1 = [0 0 1 1 1 1 0]
A2 = [0 0 0 1 0 0 0
      0 0 1 1 1 0 0
      0 0 0 1 0 0 0]
A3 = [0 0 1 1 1 0 0
      0 0 0 0 1 0 0
      0 0 0 0 1 0 0]
A4 = [0 0 1 0 0 0 0
      0 0 1 0 0 0 0
      0 0 1 0 0 0 0
      0 0 1 0 0 0 0]
A5 = [0 0 1 1 0 0 0
      0 0 1 1 0 0 0]
As = [A1, A2, A3, A4, A5]

function right(A)
    if sum(A[:, end]) == 0
        return circshift(A, (0, 1))
    else
        return A
    end
end
function left(A)
    if sum(A[:, 1]) == 0
        return circshift(A, (0, -1))
    else
        return A
    end
end

function move(A, pattern)
    if pattern == '<'
        return left(A)
    elseif pattern == '>'
        return right(A)
    else
        error("did not recogonize pattern")
    end
end

function part1(fname)
    jet_pattern = readline(fname)
    B = Set{Tuple{Int, Int}}()
    height = 3
    i = 0
    j = 0
    prev = As[j % 5 + 1]

    while j < 2022
        i += 1

        next = move(prev, jet_pattern[(i-1) % length(jet_pattern) + 1])
        next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]

        if !isempty(intersect(B, next_pts))
            next = prev
            next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]
        else
            next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]
        end
        next_pts = [x .- (1, 0) for x in next_pts]

        if !isempty(intersect(B, next_pts)) || any(x[1] == 0 for x in next_pts)
            next_pts = [x .+ (1, 0) for x in next_pts]
            foreach(x -> push!(B, x), next_pts)
            j += 1
            prev = As[j % 5 + 1]
            height = maximum(x[1] for x in B) + 3
        else
            prev = next
            height -= 1
        end
    end

    @show maximum(x[1] for x in B)
end

function illustrate(B)
    height = maximum(x[1] for x in B) + 3
    A = zeros(Bool, (height, 7));
    A[CartesianIndex.(B)] .= true;
    println()
    display(A[end:-1:1, :])
    println()
end

part1("17/test.txt")
part1("17/input.txt")

jet_pattern = readline("17/input.txt")
jet_pattern = readline("17/test.txt")
B = Set{Tuple{Int, Int}}()
height = 3
i = 0
j = 0
prev = As[j % 5 + 1]

Nmax = 1_000_000_000_000
#while j < 1_000_000_000_000
visited = false

seen_states = Dict{Tuple{Matrix{Int64}, Int, Int},Tuple{Int,Int}}()

toadd = 0
while j < Nmax
    next = move(prev, jet_pattern[i%length(jet_pattern) + 1])
    next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]

    if !isempty(intersect(B, next_pts))
        next = prev
        next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]
    else
        next_pts = [(x[1]+height, x[2]) for x in findall(==(1), next)]
    end
    next_pts = [x .- (1, 0) for x in next_pts]

    if !isempty(intersect(B, next_pts)) || any(x[1] == 0 for x in next_pts)
        next_pts = [x .+ (1, 0) for x in next_pts]
        foreach(x -> push!(B, x), next_pts)
        j += 1
        prev = As[j % 5 + 1]
        height = maximum(x[1] for x in B) + 3

        if height - 3 > 6
            key = (extract_top_n(B, 6), j%5+1, i%length(jet_pattern)+1)
            if haskey(seen_states, key) && !visited
                visited = true
                h, jold = seen_states[key]
                jnew = j - jold
                ntimes = Nmax ÷ jnew - 1
                j = jold + jnew * ntimes
                toadd = (height - 3 - h) * (ntimes - 1)
            else
                seen_states[key] = (height - 3, j)
            end
        end
    else
        prev = next
        height -= 1
    end

    i += 1
end

@show maximum(x[1] for x in B) + toadd


function extract_top_n(B, n)
    # Inspired by MarcusTL12
    A = zeros(Int, n, 7)
    height = maximum(x[1] for x in B)
    for i = 1:n, j=1:7
        A[i,j] = (height+1-i,j) ∈ B
    end
    return A
end

# test 1514285714288