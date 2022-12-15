manhattan(x, y) = sum(abs, x .- y)

y = 2_000_000
pts = Set{Tuple{Int,Int}}()
ss = Tuple{Int,Int}[]
bb = Tuple{Int,Int}[]

for line in readlines("15/input.txt")
    @show line
    reg = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
    m = match(reg, line)
    s = parse.(Int, (m.captures[1], m.captures[2]))
    b = parse.(Int, (m.captures[3], m.captures[4]))

    push!(ss, s)
    push!(bb, b)

    d = manhattan(s, b)
    dy = s[2] - y

    @show d
    if d >= abs(dy)
        k = d - abs(dy)
        for i = 0:k
            push!(pts, (s[1]+i, y))
            push!(pts, (s[1]-i, y))
        end
    end
end

for s in ss
    delete!(pts, s)
end
for b in bb
    delete!(pts, b)
end
@show length(pts)


pts = Dict{Tuple{Int,Int}, Int}()
for line in readlines("15/input.txt")
    @show line
    reg = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
    m = match(reg, line)
    s = parse.(Int, (m.captures[1], m.captures[2]))
    b = parse.(Int, (m.captures[3], m.captures[4]))

    d = manhattan(s, b)
    pts[s] = d
end

pts

function V(x1, x2)
    return maximum(max(pts[y] - manhattan((x1, x2), y) + 1, 0) for y in keys(pts))
end

xmin = 0
ymin = 0
xmax = 4000000
ymax = 4000000
stepx = max((xmax-xmin)÷1000, 1)
stepy = max((ymax-ymin)÷1000, 1)
x = xmin:stepx:xmax
y = ymin:stepy:ymax

xs = Int[]
ys = Int[]
for x1 in x, x2 in y
    if V(x1, x2) < (stepx + stepy) ÷ 2 + 1
        push!(xs, x1)
        push!(ys, x2)
    end
end

xmin = minimum(xs) - stepx
xmax = maximum(xs) + stepx
ymin = minimum(ys) - stepy
ymax = maximum(ys) + stepy
stepx = max((xmax-xmin)÷1000, 1)
stepy = max((ymax-ymin)÷1000, 1)
x = xmin:stepx:xmax
y = ymin:stepy:ymax

xs = Int[]
ys = Int[]
for x1 in x, x2 in y
    if V(x1, x2) < (stepx + stepy) ÷ 2 + 1
        push!(xs, x1)
        push!(ys, x2)
        @show V(x1, x2), x1, x2
    end
end

n = 0
nmax = length(xs)
Threads.@threads for i = 1:nmax
    x = xs[i]-stepx÷2-1:xs[i]+stepx÷2+1
    y = ys[i]-stepy÷2-1:ys[i]+stepy÷2+1
    println("i $i")
    println("x $x")
    println("y $y")
    for z1 in x, z2 in y
        if V(z1, z2) == 0
            @show V(z1, z2), z1, z2
        end
    end
end


part2 = x1*4000000 + x2