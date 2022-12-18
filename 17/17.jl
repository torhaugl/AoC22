# ####
# 
# .#.
# ###
# .#.
# 
# ..#
# ..#
# ###
# 
# #
# #
# #
# #
# 
# #

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
B = Set{Tuple{Int, Int}}()
height = 3
i = 0
j = 0
prev = As[j % 5 + 1]

while j < 1_000_000_000_000
    if (j % 1000) == 0
        @show j
    end
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

# test 1514285714288