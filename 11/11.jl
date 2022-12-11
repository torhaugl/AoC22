isdivisible(x, a) = (x % a) == 0

function parseinput(fname)
    lines = readlines(fname)
    items = Vector{Int}[]
    operations = Char[]
    operations_num = Int[]
    divnums = Int[]
    iftrues = Int[]
    iffalses = Int[]
    for line in lines
        if (startswith(line, "  Starting items"))
            numbers = parse.(Int, split(split(line, ":")[2], ","))
            push!(items, numbers)
        elseif (startswith(line, "  Operation"))
            op = split(line, "= old ")[2]
            if (contains(op, "old"))
                push!(operations, '^')
                push!(operations_num, 2)
            else
                push!(operations, op[1])
                num = parse(Int, op[2:end])
                push!(operations_num, num)
            end
            @show op
        elseif (startswith(line, "  Test"))
            divnum = parse(Int, split(line, " by ")[2])
            push!(divnums, divnum)
        elseif (startswith(line, "    If true"))
            iftrue = parse(Int, split(line, " monkey ")[2])
            push!(iftrues, iftrue+1) # Offset by 1
        elseif (startswith(line, "    If false"))
            iffalse = parse(Int, split(line, " monkey ")[2])
            push!(iffalses, iffalse+1) # Offset by 1
        end
    end
    return items, operations, operations_num, divnums, iftrues, iffalses
end

items, operations, operations_num, divnums, iftrues, iffalses = parseinput("11/input.txt")
Nmonkeys = length(items)
inspect = zeros(Int, Nmonkeys);

for _ = 1:20
    for i = 1:Nmonkeys
        for item in items[i]
            inspect[i] += 1
            if operations[i] == '+'
                newitem = floor(Int, (item + operations_num[i]) / 3)
            elseif operations[i] == '*'
                newitem = floor(Int, (item * operations_num[i]) / 3)
            elseif operations[i] == '^'
                newitem = floor(Int, (item ^ operations_num[i]) / 3)
            else
                newitem = -1
                println("ERROR")
            end

            throwto = (isdivisible(newitem, divnums[i])) ? iftrues[i] : iffalses[i]
            push!(items[throwto], newitem)
        end
        items[i] = []
    end
end

monkeybusiness = prod(sort(inspect)[end-1:end])
@show monkeybusiness

items, operations, operations_num, divnums, iftrues, iffalses = parseinput("11/input.txt")
#items = [BigInt.(i) for i in items]
Nmonkeys = length(items)
inspect = zeros(Int, Nmonkeys)
for x = 1:10_000
    if (x % 100 == 0) println(x) end
    for i = 1:Nmonkeys
        for item in items[i]
            inspect[i] += 1
            if operations[i] == '+'
                newitem = floor(BigInt, item + operations_num[i])
            elseif operations[i] == '*'
                newitem = floor(BigInt, item * operations_num[i])
            elseif operations[i] == '^'
                newitem = floor(BigInt, item ^ operations_num[i])
            else
                newitem = -1
                println("ERROR")
            end
            newitem = newitem % prod(divnums)

            throwto = (isdivisible(newitem, divnums[i])) ? iftrues[i] : iffalses[i]
            push!(items[throwto], newitem)
        end
        items[i] = BigInt[]
    end
end

part2 = prod(sort(inspect)[end-1:end])
@show part2