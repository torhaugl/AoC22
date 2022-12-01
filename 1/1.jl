function f(x)
    # Parse input
    elf = []
    weight = 0
    for line in readlines("1/1.txt")
        if line == ""
            append!(elf, weight)
            weight = 0
        else
            weight += parse(Int, line)
        end
    end
    append!(elf, weight)

    # Calculate 
    @show maximum(elf)
    @show sum(sort(elf)[end-2:end])
end

f("1/1.txt");