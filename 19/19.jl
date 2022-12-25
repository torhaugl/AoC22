function parse_input(fname)
    # (ore, clay, obsidian, geode)
    ore_robot_cost = Vector{Int}[]
    clay_robot_cost = Vector{Int}[]
    obsidian_robot_cost = Vector{Int}[]
    geode_robot_cost = Vector{Int}[]
    for line in eachline(fname)
        reg = r"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."
        m = parse.(Int, match(reg, line).captures |> collect)
        push!(ore_robot_cost, [m[2], 0, 0, 0])
        push!(clay_robot_cost, [m[3], 0, 0, 0])
        push!(obsidian_robot_cost, [m[4], m[5], 0, 0])
        push!(geode_robot_cost, [m[6], 0, m[7], 0])
    end
    return (ore_robot_cost, clay_robot_cost, obsidian_robot_cost, geode_robot_cost)
end

function iter(n, robots, currency, extra)
    if n <= 0
        return currency[4]
    end

    # Greedy return: Always buy geode-cracking robot
    if (currency[1] >= extra[4][1] && currency[2] >= extra[4][2] && currency[3] >= extra[4][3] && currency[4] >= extra[4][4])
        next_currency = currency + robots - extra[4]
        next_robots = copy(robots)
        next_robots[4] += 1
        return iter(n-1, next_robots, next_currency, extra)
    end

    v = 0

    # Only try to buy if we have fewer robots than maximum cost
    if robots[1] < extra[5][1]
        n_ore = rounds_until_buyable(currency, robots, extra[1])
        if n_ore < 0
            #do nothing
        elseif n_ore >= n
            vnew = currency[4] + robots[4] * (n-1)
            v = max(v, vnew)
        else
            next_currency = currency + (n_ore + 1) * robots - extra[1]
            new_robots = copy(robots)
            new_robots[1] += 1
            vnew = iter(n-n_ore-1, new_robots, next_currency, extra)
            v = max(v, vnew)
        end
    end
    if robots[2] < extra[5][2]
        n_ore = rounds_until_buyable(currency, robots, extra[2])
        if n_ore < 0
            #do nothing
        elseif n_ore >= n
            vnew = currency[4] + robots[4] * (n-1)
            v = max(v, vnew)
        else
            next_currency = currency + (n_ore + 1) * robots - extra[2]
            new_robots = copy(robots)
            new_robots[2] += 1
            vnew = iter(n-n_ore-1, new_robots, next_currency, extra)
            v = max(v, vnew)
        end
    end
    if robots[3] < extra[5][3]
        n_ore = rounds_until_buyable(currency, robots, extra[3])
        if n_ore < 0
            #do nothing
        elseif n_ore >= n
            vnew = currency[4] + robots[4] * (n-1)
            v = max(v, vnew)
        else
            next_currency = currency + (n_ore + 1) * robots - extra[3]
            new_robots = copy(robots)
            new_robots[3] += 1
            vnew = iter(n-n_ore-1, new_robots, next_currency, extra)
            v = max(v, vnew)
        end
    end

    # WAIT
    #next_currency = currency + robots
    #v = max(v, iter(n-1, robots, next_currency, extra))

    return v
end

function rounds_until_buyable(currency, robots, cost_robot)
    n = 0
    curr = copy(currency)
    if any(((robots[i] == 0) && (cost_robot[i] != 0)) for i = 1:4)
        return -1
    end
    while !all(curr .>= cost_robot)
        n += 1
        curr .+= robots
    end
    return n
end


function part1(n = 24)
    input = parse_input("19/test.txt")
    x = Int[]
    for i = 1:2
        oremax = max(input[1][i][1], input[2][i][1], input[3][i][1], input[4][i][1])
        clamax = max(input[1][i][2], input[2][i][2], input[3][i][2], input[4][i][2])
        obsmax = max(input[1][i][3], input[2][i][3], input[3][i][3], input[4][i][3])
        extra = (input[1][i], input[2][i], input[3][i], input[4][i], (oremax, clamax, obsmax))

        robots = [1, 0, 0, 0]
        currency = [0, 0, 0, 0]
        @time push!(x, iter(n, robots, currency, extra))
	@show x[end]
    end
    return x
end

function part2(n = 32)
    input = parse_input("19/input.txt")
    x = Int[]
    for i = 1:3
        oremax = maximum((input[1][i][1], input[2][i][1], input[3][i][1], input[4][i][1]))
        clamax = maximum((input[1][i][2], input[2][i][2], input[3][i][2], input[4][i][2]))
        obsmax = maximum((input[1][i][3], input[2][i][3], input[3][i][3], input[4][i][3]))
        extra = (input[1][i], input[2][i], input[3][i], input[4][i], (oremax, clamax, obsmax))

        robots = [1, 0, 0, 0]
        currency = [0, 0, 0, 0]
        @time push!(x, iter(n, robots, currency, extra))
	@show x[end]
    end
    return x
end


using Profile
part1(10)
Profile.clear_malloc_data()
part1(10)
#@show part1(1)
#@show part1(20)
#@show part1(20)
#@show part1(21)
#@show part1(22)
#@show part1(23)
#@show part1(24)
#@show part2(32)
