source = [500, 0]
positions = Matrix{Int64}[]
for line in readlines("14/input.txt")
    nums = parse.(Int, split(join(split(line, "->"), ','), ','))
    pos = reshape(nums, (2, length(nums)÷2))'
    push!(positions, pos)
    @show pos
end

function makeline(pos1, pos2)
    d = pos2 .- pos1
    if d[1] != 0
        out = [pos1 .+ [i, 0] for i = 0:sign(d[1]):d[1]]
    elseif d[2] != 0
        out = [pos1 .+ [0, i] for i = 0:sign(d[2]):d[2]]
    else
        out = []
        println("ERROR")
    end
    return out
end

all_xy = Set{Vector{Int}}()
for pos_mat in positions
    for i = 1:size(pos_mat,1)-1
        for pos in makeline(pos_mat[i,:], pos_mat[i+1,:])
            push!(all_xy, pos)
        end
    end
end
all_xy

n = 0
x = copy(source)
max_check = maximum(maximum(position[:,2]) for position in positions)
while true
    if (x .+ [0, 1]) ∉ all_xy
        x .+= [0, 1]
        if (x[2] > max_check )
            println("STOP")
            break
        end
    elseif (x .+ [-1, 1]) ∉ all_xy
        x .+= [-1, 1]
    elseif (x .+ [1, 1]) ∉ all_xy
        x .+= [1, 1]
    else
        n += 1
        push!(all_xy, x)
        x = copy(source)
    end
end
all_xy
println("PART1");
@show n;



all_xy = Set{Vector{Int}}()
for pos_mat in positions
    for i = 1:size(pos_mat,1)-1
        for pos in makeline(pos_mat[i,:], pos_mat[i+1,:])
            push!(all_xy, pos)
        end
    end
end

n = 0
x = copy(source)
max_check = maximum(maximum(position[:,2]) for position in positions)

for pos in makeline([-2000, max_check + 2], [2000, max_check + 2])
    push!(all_xy, pos)
end

while true
    if (x .+ [0, 1]) ∉ all_xy
        x .+= [0, 1]
    elseif (x .+ [-1, 1]) ∉ all_xy
        x .+= [-1, 1]
    elseif (x .+ [1, 1]) ∉ all_xy
        x .+= [1, 1]
    else
        n += 1
        push!(all_xy, x)
        if (x == source)
            break
        end
        x = copy(source)
    end
end
all_xy
@show n