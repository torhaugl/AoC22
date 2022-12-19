function parse_input(fname)
    # (ore, clay, obsidian, geode)
    ore_robot_cost = Tuple{Int, Int, Int, Int}[]
    clay_robot_cost = Tuple{Int, Int, Int, Int}[]
    obsidian_robot_cost = Tuple{Int, Int, Int, Int}[]
    geode_robot_cost = Tuple{Int, Int, Int, Int}[]
    for line in eachline(fname)
        reg = r"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."
        m = parse.(Int, match(reg, line).captures |> collect)
        push!(ore_robot_cost, (m[2], 0, 0, 0))
        push!(clay_robot_cost, (m[3], 0, 0, 0))
        push!(obsidian_robot_cost, (m[4], m[5], 0, 0))
        push!(geode_robot_cost, (m[6], 0, m[7], 0))
    end
    return (ore_robot_cost, clay_robot_cost, obsidian_robot_cost, geode_robot_cost)
end

function iter(n, robots, currency, extra)
    if n <= 0
        return currency[4]
    end

    v = 0
    #@show currency, robots
    if all(currency .>= extra[1])
        currency .-= extra[1]
        next_robots = copy(robots) .+ (1, 0, 0, 0)
        v = max(v, iter(n-1, next_robots, currency, extra))
        currency .+= extra[1]
    end
    if all(currency .>= extra[2])
        currency .-= extra[2]
        next_robots = copy(robots) .+ (0, 1, 0, 0)
        v = max(v, iter(n-1, next_robots, currency, extra))
        currency .+= extra[2]
    end
    if all(currency .>= extra[3])
        currency .-= extra[3]
        next_robots = copy(robots) .+ (0, 0, 1, 0)
        v = max(v, iter(n-1, next_robots, currency, extra))
        currency .+= extra[3]
    end
    if all(currency .>= extra[4])
        currency .-= extra[4]
        next_robots = copy(robots) .+ (0, 0, 0, 1)
        v = max(v, iter(n-1, next_robots, currency, extra))
        currency .+= extra[4]
    end

    next_currency = copy(currency) .+ robots
    v = max(v, iter(n-1, robots, next_currency, extra))

    return v
end

input = parse_input("19/test.txt")
extra = (input[1][1], input[2][1], input[3][1], input[4][1])
robots = [1, 0, 0, 0]
currency = [0, 0, 0, 0]

iter(25, robots, currency, extra)