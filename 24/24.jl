using DataStructures

dir_map = Dict('<' => (-1,0), '>' => (1, 0), '^' => (0, 1), 'v' => (0, -1))

function parse_input_sparse(fname)
    lines = readlines(fname)
    walls = NTuple{2, Int}[]
    blizzard = Pair{NTuple{2, Int}, NTuple{2, Int}}[]
    elf = NTuple{2, Int}
    goal = NTuple{2, Int}
    for (i, line) in enumerate(lines), (j, c) in enumerate(line)
        x = j
        y = length(lines) + 1 - i
        if c == '#'
            push!(walls, (x, y))
        elseif c ∈ "<>v^"
            push!(blizzard, (x, y) => dir_map[c])
        elseif c == 'E'
            elf = (x, y)
            push!(walls, (x, y + 1))
        elseif c == 'G'
            goal = (x, y)
            push!(walls, (x, y - 1))
        end
    end
    return elf, goal, blizzard, walls
end


function moves(elf, blizzard, walls)
    move_list = NTuple{2, Int}[]
    poss_move = [(0,0), (0,1), (1,0), (-1,0), (0,-1)]
    for move in poss_move
        next = elf .+ move
        if next ∉ walls && next ∉ blizzard
            push!(move_list, next)
        end
    end
    return move_list
end

function move_blizzard(blizzard, walls)
    new = Pair{NTuple{2, Int}, NTuple{2, Int}}[]
    xmax = maximum(x[1] for x in walls)
    ymax = maximum(x[2] for x in walls) - 1
    for k in blizzard
        next = k[1] .+ k[2]
        if next ∈ walls
            if next[1] == 1
                next = (next[1] + xmax - 2, next[2])
            elseif next[1] == xmax
                next = (next[1] - xmax + 2, next[2])
            elseif next[2] == 1
                next = (next[1], next[2] + ymax - 2)
            elseif next[2] == ymax
                next = (next[1], next[2] - ymax + 2)
            end
        end
        push!(new, next => k[2])
    end
    return new
end

function start_search(start, goal, blizzard, walls, skip=false)
    Q = Queue{Tuple{Int, NTuple{2, Int}}}()
    @show start, goal

    enqueue!(Q, (0, start))
    if !skip
    blizzard = move_blizzard(blizzard, walls)
    end
    blizz_x = [x[1] for x in blizzard]
    n_blizz = 0

    while !isempty(Q)
        n, elf = dequeue!(Q)

        if elf == goal
            return n, blizzard
        end

        if n_blizz != n
            n_blizz = n
            blizzard = move_blizzard(blizzard, walls)
            blizz_x = [x[1] for x in blizzard]
        end

        for new_elf in moves(elf, blizz_x, walls)
            if (n+1, new_elf) ∉ Q
                enqueue!(Q, (n+1, new_elf))
            end
        end
    end
end

function part1()
    start, goal, blizzard, walls = parse_input_sparse("24/input.txt")

    n, _ = start_search(start, goal, blizzard, walls)
    return n
end

function part2()
    start, goal, blizzard, walls = parse_input_sparse("24/input.txt")
    @show start goal

    n1, blizzard = start_search(start, goal, blizzard, walls)
    n2, blizzard = start_search(goal, start, blizzard, walls, true)
    n3, blizzard = start_search(start, goal, blizzard, walls, true)
    ntot = n1 + n2 + n3
    return ntot, n1, n2, n3
end

@time part1()
@time part2()