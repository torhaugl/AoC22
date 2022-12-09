using DataStructures

lines = readlines("9/input.txt")

function char2dir(c)
    if c == 'L'
        return (-1,0)
    elseif c == 'R'
        return (+1,0)
    elseif c == 'D'
        return (0,-1)
    elseif c == 'U'
        return (0,+1)
    end
end

N = 10
rope = [(0, 0) for _=1:N]
visited = Set{Tuple{Int, Int}}()
push!(visited, rope[end])

for line in lines
    dir_head = char2dir(line[1])
    steps = parse(Int, split(line)[2])

    for _ = 1:steps
        rope[1] = rope[1] .+ dir_head

        for i = 2:N
            d = rope[i-1] .- rope[i]

            if maximum(abs.(d)) < 2
                continue
            end

            if minimum(abs.(d)) == 0
                dir = d .÷ 2
                rope[i] = rope[i] .+ dir
            else
                dir = d .÷ abs.(d)
                rope[i] = rope[i] .+ dir
            end

        end

        push!(visited, rope[end])
    end
end

length(visited)