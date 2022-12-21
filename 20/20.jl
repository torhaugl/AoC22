lines = readlines("20/test.txt")
A = zeros(Int, length(lines))
B = 1:length(lines) |> collect
for (i, line) in enumerate(lines)
    A[i] = parse(Int, line)
end

function move(A, i, n)
    dir = sign(n)
    amt = abs(n)
    key = A[i]
    C = copy(A)
    while amt > 0
        amt -= 1
        C[i + amt*dir + dir] = C[i + amt*dir]
    end
    amt += 1
    C[i + amt*dir] = key
    return C
end