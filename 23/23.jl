using DataStructures
# FIRST HALF
# If no other Elves are in one of those eight positions, the Elf does not do anything during this round. Otherwise, the Elf looks in each of four directions in the following order and proposes moving one step in the first valid direction:
# If there is no Elf in the N, NE, or NW adjacent positions, the Elf proposes moving north one step.
# If there is no Elf in the S, SE, or SW adjacent positions, the Elf proposes moving south one step.
# If there is no Elf in the W, NW, or SW adjacent positions, the Elf proposes moving west one step.
# If there is no Elf in the E, NE, or SE adjacent positions, the Elf proposes moving east one step.

# SECOND HALF
# If two or more Elves propose moving to the same position, none of those Elves move.
# Else, move

# END
# The first direction the Elves considered is moved to the end of the list of directions.

function parse_input_sparse(fname)
    lines = readlines(fname)
    elves = NTuple{2, Int}[]
    for (i, line) in enumerate(lines), (j, c) in enumerate(line)
        if c == '#'
            push!(elves, (length(lines) + 1- i, j))
        end
    end
    return elves
end

function general!(dict, elves, where2check, move)
    for elf in elves
        if elf ∉ keys(dict) && all(elf .+ n ∉ elves for n in where2check)
            dict[elf] = elf .+ move
        end
    end
end

neighborhood = [(-1,-1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
still!(dict, elves) = general!(dict, elves, neighborhood, (0,0))
north!(dict, elves) = general!(dict, elves, [(1,-1), (1,0), (1,1)], (1,0))
south!(dict, elves) = general!(dict, elves, [(-1,-1), (-1,0), (-1,1)], (-1,0))
west!(dict, elves) =  general!(dict, elves, [(-1,-1), (0,-1), (1,-1)], (0,-1))
east!(dict, elves) =  general!(dict, elves, [(-1,1), (0,1), (1,1)], (0,+1))
function do_nothing!(dict, elves)
    for elf in elves
        if elf ∉ keys(dict)
            dict[elf] = elf
        end
    end
end


function remove_doubles!(propose)
    ctr = counter(values(propose))
    ids = findall(x -> x>1, ctr)
    for id in ids
        rm = findall(x -> x==id, propose)
        for r in rm
            propose[r] = r
        end
    end
end


function part1(n)
    elves = parse_input_sparse("23/input.txt")
    checks = [north!, south!, west!, east!]
    propose = Dict{NTuple{2, Int}, NTuple{2, Int}}()

    for _ = 1:10
        empty!(propose)
        still!(propose, elves)
        for check in checks
            check(propose, elves)
        end
        do_nothing!(propose, elves)
        circshift!(checks, -1)
        remove_doubles!(propose)
        elves = sort(collect(values(propose)))
    end

    y = [elf[1] for elf in elves]
    x = [elf[2] for elf in elves]

    part1_num = (maximum(y) - minimum(y) + 1) * (maximum(x)-minimum(x)+1) - length(elves)
    @show part1_num
end

function part2()
    elves = parse_input_sparse("23/input.txt")
    checks = [north!, south!, west!, east!]
    propose = Dict{NTuple{2, Int}, NTuple{2, Int}}()
    propose[(0,0)] = (1000, 1000)

    n = 0
    while !all(x == propose[x] for x in keys(propose))
        diff = sum(x != propose[x] for x in keys(propose))
        n += 1
        @show n, diff
        empty!(propose)
        still!(propose, elves)
        for check in checks
            check(propose, elves)
        end
        do_nothing!(propose, elves)
        circshift!(checks, -1)
        remove_doubles!(propose)
        elves = sort(collect(values(propose)))
    end

    @show n
end

part1(10)
part2()

### TESTING 

#elves1 = sort(parse_input_sparse("23/test1.txt"))
#elves1 = [elf .- elves1[1] .+ elves[1] for elf in elves1]
#elves == elves1
#hcat(elves, elves1)

#elves2 = sort(parse_input_sparse("23/test2.txt"))
#elves2 = [elf .- elves2[1] .+ elves[1] for elf in elves2]
#elves == elves2
#hcat(elves, elves2)

#A = zeros(Int, maximum(y)-minimum(y)+1, maximum(x)-minimum(x)+1)
#for elf in elves
#    A[elf[1]-minimum(y)+1, elf[2]-minimum(x)+1] = 1
#end
#replace(A[end:-1:1,:], 0=>'.', 1=>'#')


### CONVOLVE STUFF
#
# function parse_input_matrix(fname)
#     lines = readlines(fname)
#     A = falses(length(lines), length(lines[1]))
#     for (i, line) in enumerate(lines), (j, c) in enumerate(line)
#         A[i, j] = (c == '#')
#     end
#     return A
# end
# 
# using PyCall
# sig = pyimport("scipy.signal")
# 
# conv = [1 1 1; 1 0 1; 1 1 1]
# moving = (sig.convolve(elves, conv, mode="same") .* elves) .> 2
# 
# conv_N = [0 0 0; 0 0 0; 1 1 1]
# moving_N = (((sig.convolve(elves, conv_N, mode="same") .* elves) .> 0) .+ elves) .== 1
# 
# conv_S = [1 1 1; 0 0 0; 0 0 0]
# moving_S = (((sig.convolve(elves, conv_S, mode="same") .* elves) .> 0) .+ elves) .== 1
# 
# conv_E = [1 0 0; 1 0 0; 1 0 0]
# moving_E = (((sig.convolve(elves, conv_E, mode="same") .* elves) .> 0) .+ elves) .== 1
# 
# conv_W = [0 0 1; 0 0 1; 0 0 1]
# moving_W = (((sig.convolve(elves, conv_W, mode="same") .* elves) .> 0) .+ elves) .== 1