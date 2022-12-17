using DataStructures
using Memoize

function part1(n)
    global flowchart = Dict{String, Int}()
    global flowmap = Dict{String, Vector{String}}()

    lines = readlines("16/input.txt")
    for line in lines
        reg = r"Valve ([A-Z]+) has flow rate=(\d+); tunnels lead to valves ([A-Z]+), ([A-Z]+), ([A-Z]+), ([A-Z]+), ([A-Z]+)"
        m = match(reg, line)
        if isnothing(m)
            reg = r"Valve ([A-Z]+) has flow rate=(\d+); tunnels lead to valves ([A-Z]+), ([A-Z]+), ([A-Z]+), ([A-Z]+)"
            m = match(reg, line)
        end
        if isnothing(m)
            reg = r"Valve ([A-Z]+) has flow rate=(\d+); tunnels lead to valves ([A-Z]+), ([A-Z]+), ([A-Z]+)"
            m = match(reg, line)
        end
        if isnothing(m)
            reg = r"Valve ([A-Z]+) has flow rate=(\d+); tunnels lead to valves ([A-Z]+), ([A-Z]+)"
            m = match(reg, line)
        end
        if isnothing(m)
            reg = r"Valve ([A-Z]+) has flow rate=(\d+); tunnel leads to valve ([A-Z]+)"
            m = match(reg, line)
        end

        start = m.captures[1]
        flow = parse(Int, m.captures[2])
        tunnel = m.captures[3:end]
        flowchart[start] = flow
        flowmap[start] = tunnel
    end

    start = "AA"
    flowopen = Dict{String, Int}()

    @time iter(start, flowopen, n)
end

function iter(node, flowopen, n)
    act = actions(flowopen)
    if n <= 0 || isempty(act)
        return sum(values(flowopen))
    end

    s = 0
    for action in act
        nminus = dist(node, action)
        if n - nminus - 1 > 0
            flowopen[action] = (n-nminus-1) * flowchart[action]
        end
        v = iter(action, flowopen, n-nminus-1)
        s = max(s, v)
        delete!(flowopen, action)
    end
    return s
end

@memoize function dist(x, y)
    # BFS. Distance between points in flowmap
    q = Queue{String}()
    enqueue!(q, x)
    dd = Dict{String, Int}(x => 0)
    while !isempty(q)
        v = dequeue!(q)
        if v == y
            return dd[v]
        end
        for edge in flowmap[v]
            alt = dd[v] + 1
            if edge ∉ keys(dd)
                dd[edge] = alt
                enqueue!(q, edge)
            end
        end
    end
    error("not found")
end

function actions(flowopen)
    x = Set(findall(!=(0), flowchart))
    for y in keys(flowopen)
        delete!(x, y) 
    end
    return x
end

@time part1(30)