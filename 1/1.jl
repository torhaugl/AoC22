# Split vector by delimiter
import Base.split
function split(x::AbstractVector, dlm)
    loc = findall(==(dlm), x)
    getindex.(Ref(x), UnitRange.([1; loc .+ 1], [loc .- 1; length(x)]))
end

function f(fname)
    lines = readlines(fname)

    all_calories = zeros(Int, length(lines))
    for (i, line) in enumerate(lines)
        try
            all_calories[i] = parse(Int, line)
        catch # line == ""
            all_calories[i] = -1
        end
    end

    elf_calories = sum.(split(all_calories, -1))
    
    # Calculate 
    @show maximum(elf_calories)
    @show sum(sort(elf_calories)[end-2:end])
end

f("1/1.txt");
