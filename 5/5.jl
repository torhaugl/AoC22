using DataStructures

function stacks()
    q1 = Stack{Char}()
    for c in reverse(['M', 'S', 'J', 'L', 'V', 'F', 'N', 'R'])
    push!(q1, c)
    end
    q2 = Stack{Char}()
    for c in reverse(['H', 'W', 'J', 'F', 'Z', 'D', 'N', 'P'])
        push!(q2, c)
    end
    q3 = Stack{Char}()
    for c in reverse(['G', 'D', 'C', 'R', 'W'])
        push!(q3, c)
    end
    q4 = Stack{Char}()
    for c in reverse(['S', 'B', 'N'])
    push!(q4, c)
    end
    q5 = Stack{Char}()
    for c in reverse(['N', 'F', 'B', 'C', 'P', 'W', 'Z', 'M'])
    push!(q5, c)
    end
    q6 = Stack{Char}()
    for c in reverse(['W', 'M', 'R', 'P'])
        push!(q6, c)
    end
    q7 = Stack{Char}()
    for c in reverse(['W', 'S', 'L', 'G', 'N', 'T', 'R'])
        push!(q7, c)
    end
    q8 = Stack{Char}()
    for c in reverse(['V', 'B', 'N', 'F', 'H', 'T', 'Q'])
    push!(q8, c)
    end
    q9 = Stack{Char}()
    for c in reverse(['F', 'N', 'Z', 'H', 'M', 'L'])
    push!(q9, c)
    end
    qs = [q1,q2,q3,q4,q5,q6,q7,q8,q9]
    return qs
end

lines = readlines("5/input.txt")
N = length(lines)
qs = stacks()
for i = 1:N
    line = lines[i]
    r = eachmatch(r"(\d+)", line) |> collect
    a = parse(Int, r[1].match)
    b = parse(Int, r[2].match)
    c = parse(Int, r[3].match)
    for _ = 1:a
        x = pop!(qs[b])
        push!(qs[c], x)
    end
end
for q in qs
    print(pop!(q))
end

lines = readlines("5/input.txt")
N = length(lines)
qs = stacks()
for i = 1:N
    line = lines[i]
    r = eachmatch(r"(\d+)", line) |> collect
    a = parse(Int, r[1].match)
    b = parse(Int, r[2].match)
    c = parse(Int, r[3].match)
    xs = []
    for _ = 1:a
        x = pop!(qs[b])
        append!(xs, x)
    end
    for x in reverse(xs)
        push!(qs[c], x)
    end
end

println()
for q in qs
    print(pop!(q))
end