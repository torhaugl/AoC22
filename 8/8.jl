lines = readlines("8/input.txt")
A = zeros(Int, length(lines[1]), length(lines))

for (i, line) in enumerate(lines), (j, c) in enumerate(line)
    A[i,j] = parse(Int, c)
end

N = size(A, 1)
visible = CartesianIndex[]
for j = 1:N
    top = -1
    for i = 1:N
        if A[j, i] > top
            top = A[j, i]
            push!(visible, CartesianIndex(j, i))
        end
    end
    top = -1
    for i = N:-1:1
        if A[j, i] > top
            top = A[j, i]
            push!(visible, CartesianIndex(j, i))
        end
    end
    top = -1
    for i = 1:N
        if A[i, j] > top
            top = A[i, j]
            push!(visible, CartesianIndex(i, j))
        end
    end
    top = -1
    for i = N:-1:1
        if A[i, j] > top
            top = A[i, j]
            push!(visible, CartesianIndex(i, j))
        end
    end
end



function count_trees(A, i, j)
    score = Int[]
    top = A[i,j]
    s = 0
    for k = i+1:N
        s += 1
        if top <= A[k, j]
            break
        end
    end
    push!(score, s)

    s = 0
    for k = i-1:-1:1
        s += 1
        if top <= A[k, j]
            break
        end
    end
    push!(score, s)

    s = 0
    for k = j+1:N
        s += 1
        if top <= A[i, k]
            break
        end
    end
    push!(score, s)

    s = 0
    for k = j-1:-1:1
        s += 1
        if top <= A[i, k]
            break
        end
    end
    push!(score, s)
    return prod(score)
end


unique(visible) |> length
B = similar(A)
for i = 1:N
    for j = 1:N
        B[i, j] = count_trees(A, i, j)
    end
end
B

maximum(B)