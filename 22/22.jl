function parse_input(fname)
    lines = readlines(fname)
    grounds = Vector{Int}[]
    walls = Vector{Int}[]
    start = [0, 0]
    for (i, line) in enumerate(lines[1:end-2]), (j, c) in enumerate(line)
        x = j
        y = i
        if c == '.'
            push!(grounds, [x, y])
        elseif c == '#'
            push!(grounds, [x, y])
            push!(walls, [x, y])
        elseif c == 'S'
            push!(grounds, [x, y])
            start = [x, y]
        end
    end

    instructions = replace(lines[end], 'R' => " R ", 'L' => " L ") |> split
    
    return start, grounds, walls, instructions
end


function move(start, dir, ground, walls)
    new = start + dir
    if new ∉ ground
        new = start
        while new ∈ ground
            new = new - dir
        end
        new = new + dir
    end
    if new ∈ walls
        return start
    end
    return new
end


function part1()
    start, grounds, walls, instructions = parse_input("22/input.txt")
    pos = copy(start)
    dir = [1, 0]
    L = [ 0  1
        -1  0]
    R = [ 0 -1
        1  0]
    for inst in instructions
        if isnumeric(inst[1])
            i = parse(Int, inst)
            for _ = 1:i
                pos = move(pos, dir, grounds, walls)
            end
        else
            if inst == "L"
                dir = L * dir
            elseif inst == "R"
                dir = R * dir
            else
                println("ERROR: $inst")
            end
        end
    end
    dir2num = Dict([1,0] => 0, [0,1] => 1, [-1,0] => 2, [0, -1] => 3)

    final_password = pos[2] * 1000 + pos[1] * 4 + dir2num[dir]
    return final_password
end


### PART 2

function parse_input2()
    lines = readlines("22/input.txt")
    lines_cube = readlines("22/input_cube.txt")
    grounds = Vector{Int}[]
    walls = Vector{Int}[]
    ground2side = Dict{Vector{Int}, Int}()
    start = [0, 0]
    for (i, line) in enumerate(lines[1:end-2]), (j, c) in enumerate(line)
        x = j
        y = i
        if c == '.' || c == 'S'
            push!(grounds, [x, y])
            ground2side[[x,y]] = parse(Int, lines_cube[i][j])
        elseif c == '#'
            push!(grounds, [x, y])
            push!(walls, [x, y])
            ground2side[[x,y]] = parse(Int, lines_cube[i][j])
        end
    end

    ground1 = [[ground for ground in grounds if ground2side[ground] == i] for i =1:6]
    wall1 = [[wall for wall in walls if ground2side[wall] == i] for i =1:6]
    for i = 1:6
        xmin = minimum(g[1] for g in ground1[i])
        ymin = minimum(g[2] for g in ground1[i])
        ground1[i] = [w - [xmin, ymin] for w in ground1[i]]
        wall1[i] = [w - [xmin, ymin] for w in wall1[i]]
    end

    instructions = replace(lines[end], 'R' => " R ", 'L' => " L ") |> split
    
    return ground1, wall1, instructions
end

function part2()
    ground1, wall1, instructions = parse_input2()

    pos = [0, 0]
    dir = [1, 0]
    side = 1

    L = [ 0  1
        -1  0]
    R = [ 0 -1
        1  0]
    for inst in instructions
        if isnumeric(inst[1])
            i = parse(Int, inst)
            for _ = 1:i
                pos, dir, side = move2(pos, dir, side, ground1, wall1)
                #@show pos, side
            end
        else
            if inst == "L"
                dir = L * dir
            elseif inst == "R"
                dir = R * dir
            else
                println("ERROR: $inst")
            end
        end
    end

    @show pos, dir, side
    return pos, dir, side
end

# (side=1,pos=(50,y),dir=(1,0)) = (side=2,pos=(0,y),dir=(1,0))
# (side=1,pos=(x,50),dir=(0,1)) = (side=6,pos=(0,49-x),dir=(1,0))
# (side=1,pos=(-1,y),dir=(-1,0)) = (side=4,pos=(0,49-x),dir=(1,0))
# (side=1,pos=(x,-1),dir=(0,-1)) = (side=3,pos=(x,49),dir=(0,-1))
# (side=2,pos)


function move2(start, dir, side, ground, walls)
    new = start + dir
    start_dir = copy(dir)
    inside = copy(side)
    if new ∉ ground[side]
        right = [1, 0]
        down = [0, 1]
        left = [-1, 0]
        up = [0, -1]
        x = start[1]
        y = start[2]
        if side == 1 && dir == right
            side = 2
            new  = [0, y]
            dir  = dir
        elseif side == 1 && dir == down
            side = 3
            new  = [x, 0]
            dir  = dir
        elseif side == 1 && dir == left
            side = 4
            new  = [0, 49-y]
            dir  = right
        elseif side == 1 && dir == up
            side = 6
            new  = [0, x]
            dir  = right
        elseif side == 2 && dir == right
            side = 5
            new  = [49, 49-y]
            dir  = left
        elseif side == 2 && dir == down
            side = 3
            new  = [49, x]
            dir  = left
        elseif side == 2 && dir == left
            side = 1
            new  = [49, y]
            dir  = dir
        elseif side == 2 && dir == up
            side = 6
            new  = [x, 49]
            dir  = dir
        elseif side == 3 && dir == right
            side = 2
            new  = [y, 49]
            dir  = up
        elseif side == 3 && dir == down
            side = 5
            new  = [x, 0]
            dir  = dir
        elseif side == 3 && dir == left
            side = 4
            new  = [y, 0]
            dir  = down
        elseif side == 3 && dir == up
            side = 1
            new  = [x, 49]
            dir  = dir
        elseif side == 4 && dir == right
            side = 5
            new  = [0, y]
            dir  = dir
        elseif side == 4 && dir == down
            side = 6
            new  = [x, 0]
            dir  = down
        elseif side == 4 && dir == left
            side = 1
            new  = [0, 49-y]
            dir  = right
        elseif side == 4 && dir == up
            side = 3
            new  = [0, x]
            dir  = right
        elseif side == 5 && dir == right
            side = 2
            new  = [49, 49-y]
            dir  = left
        elseif side == 5 && dir == down
            side = 6
            new  = [49, x]
            dir  = left
        elseif side == 5 && dir == left
            side = 4
            new  = [49, y]
            dir  = dir
        elseif side == 5 && dir == up
            side = 3
            new  = [x, 49]
            dir  = dir
        elseif side == 6 && dir == right
            side = 5
            new  = [y, 49]
            dir  = up
        elseif side == 6 && dir == down
            side = 2
            new  = [x, 0]
            dir  = dir
        elseif side == 6 && dir == left
            side = 1
            new  = [y, 0]
            dir  = down
        elseif side == 6 && dir == up
            side = 4
            new  = [x, 49]
            dir  = dir
        end

        if inside == side
            println("ERROR $side")
        end
    end
    if new ∈ walls[side]
        return start, start_dir, inside
    else
        return new, dir, side
    end
end

part1()
part2()
# 74*4+135*1000+1