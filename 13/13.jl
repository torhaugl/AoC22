function smallerthan(x::Any, y::Any) 
    for (x_el, y_el) in zip(x, y)
        if smallerthan(x_el, y_el)
            return true
        elseif smallerthan(y_el, x_el)
            return false
        else
            continue
        end
    end
    return length(x) < length(y)
end

smallerthan(x::Vector{Int}, y::Int) = smallerthan(x, [y])
smallerthan(x::Int, y::Vector{Int}) = smallerthan([x], y)
smallerthan(x::Int, y::Int) = x < y

# PART 1
lines = readlines("13/input.txt")
st = Int[]
for i = 1:3:length(lines)
    x = eval(Meta.parse(lines[i]))
    y = eval(Meta.parse(lines[i+1]))

    sts = smallerthan(x, y)
    if sts
        push!(st, 1+(i÷3))
    end
    @show 1+(i÷3),sts
end
@show sum(st)

# PART 2
lines = readlines("13/input.txt")
parsed = []
push!(parsed, [[2]])
push!(parsed, [[6]])
for i = 1:length(lines)
    if lines[i] == ""
        continue
    end
    x = eval(Meta.parse(lines[i]))
    push!(parsed, x)
end

x = sort(parsed, lt=smallerthan)

@show findfirst(==([[2]]), x) * findfirst(==([[6]]), x)