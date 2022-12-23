using CircularArrays

function parse_input(fname)
    lines = readlines(fname)
    A = zeros(Int, length(lines))
    B = 1:length(lines) |> collect
    for (i, line) in enumerate(lines)
        A[i] = parse(Int, line)
    end

    A = CircularVector(A)
    B = CircularVector(B)
    return A, B
end

function move(B, i, t)
    times = t % (length(B)-1)
    temp = B[i]
    if times >= 0
        for j = i:i+times-1
            B[j] = B[j+1]
        end
        B[i+times] = temp
    else
        for j = i:-1:i+times
            B[j] = B[j-1]
        end
        B[i+times] = temp
    end
end

function solve_part1()
    A, B = parse_input("20/input.txt")
    for i = 1:length(A)
        n = findfirst(==(i), B)
        x = A[n]
        move(A, n, x)
        move(B, n, x)
    end
    n0 = findfirst(==(0), A)
    @show A[n0 + 1000] + A[n0 + 2000] + A[n0 + 3000]
end


# PART 2
function solve_part2()
    A, B = parse_input("20/input.txt")
    decryption_key = 811589153
    A *= decryption_key
    for _ = 1:10
        for i = 1:length(A)
            n = findfirst(==(i), B)
            x = A[n]
            move(A, n, x)
            move(B, n, x)
        end
    end
    n0 = findfirst(==(0), A)
    @show A[n0 + 1000] + A[n0 + 2000] + A[n0 + 3000]
end

solve_part1()
solve_part2()