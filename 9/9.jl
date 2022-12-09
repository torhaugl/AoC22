lines = readlines("9/input.txt")

function movehead(s, c)
    if c == 'L'
        return s .- (1,0)
    elseif c == 'R'
        return s .+ (1,0)
    elseif c == 'D'
        return s .- (0,1)
    elseif c == 'U'
        return s .+ (0,1)
    else
        println("error")
    end
end

dist(x, y) = sum(abs, x .- y)

N = 10
rope = [(0, 0) for _=1:10]
visited = Tuple{Int, Int}[]
push!(visited, rope[end])

for line in lines
    dir = line[1]
    steps = parse(Int, split(line)[2])
    for _ = 1:steps
        rope[1] = movehead(rope[1], dir)
        for i = 2:N
            d = rope[i-1] .- rope[i]
            if maximum(abs.(d)) == 2 && minimum(abs.(d)) == 0
                dir_T = d .÷ 2
                rope[i] = rope[i] .+ dir_T
            elseif maximum(abs.(d)) == 2 && minimum(abs.(d)) == 1
                dir_T = d .÷ abs.(d)
                rope[i] = rope[i] .+ dir_T
            elseif maximum(abs.(d)) == 2 && minimum(abs.(d)) == 2
                dir_T = d .÷ abs.(d)
                rope[i] = rope[i] .+ dir_T
            end
        end

        push!(visited, rope[end])
    end
end

length(unique(visited))