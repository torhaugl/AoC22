using DataStructures

function parseinput(fname)
    flowchart = Dict{String, Int}()
    flowmap = Dict{String, Vector{String}}()
    lines = readlines(fname)
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
    return flowchart, flowmap
end

function part1(n; fname="16/input.txt")
    flowchart, flowmap = parseinput(fname)
    distdist = get_distdistmatrix(flowmap)
    flowzero = Set(findall(!=(0), flowchart))

    start = "AA"
    flowopen = Dict{String, Int}()
    extra = (flowchart, distdist, flowzero)

    @time iter(start, flowopen, n, extra)
end

function iter(node, flowopen, n, extra)
    flowchart, distdist, flowzero = extra

    act = flowzero
    if n <= 0 || length(flowzero) == length(flowopen)
        return sum(values(flowopen))
    end

    s = 0
    for action in act
        if action ∈ keys(flowopen)
            continue
        end
        nminus = distdist[(node, action)]
        if n - nminus - 1 > 0
            flowopen[action] = (n-nminus-1) * flowchart[action]
        end
        v = iter(action, flowopen, n-nminus-1, extra)
        s = max(s, v)
        delete!(flowopen, action)
    end
    return s
end

function dist(x, y, flowmap)
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

function get_distdistmatrix(flowmap)
    matrix = Dict{Tuple{String,String}, Int}()
    for x in keys(flowmap), y in keys(flowmap)
        matrix[(x,y)] = dist(x, y, flowmap)
    end
    return matrix
end

function iter2(node, flowopen, n, elephant, extra)
    flowchart, distdist, flowzero, nmax  = extra
    act = flowzero
    if n <= 0 || length(flowzero) == length(flowopen)
        if elephant 
            return sum(values(flowopen))
        else
            return iter2("AA", flowopen, nmax, true, extra)
        end
    end

    s = 0
    for action in act
        if action ∈ keys(flowopen)
            continue
        end
        nminus = distdist[(node, action)]
        if n - nminus - 1 > 0
            flowopen[action] = (n-nminus-1) * flowchart[action]
        end
        v = iter2(action, flowopen, n-nminus-1, elephant, extra)
        s = max(s, v)
        delete!(flowopen, action)
    end
    if !elephant
        v = iter2("AA", flowopen, nmax, true, extra)
        s = max(s, v)
    end
    return s
end

function part2(n; fname="16/input.txt")
    flowchart, flowmap = parseinput(fname)
    distdist = get_distdistmatrix(flowmap)
    flowzero = Set(findall(!=(0), flowchart))

    start = "AA"
    flowopen = Dict{String, Int}()
    extra = (flowchart, distdist, flowzero, n)

    @time iter2(start, flowopen, n, false, extra)
end


part1(3)
@show part1(30; fname="16/test.txt");
@show part1(30; fname="16/input.txt");

part2(3)
@show part2(26; fname="16/test.txt");
@show part2(26; fname="16/input.txt");