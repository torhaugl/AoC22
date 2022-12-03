lines = readlines("3/3.txt")
priority = 0
for line in lines
    N = length(line)
    comp1 = [islowercase(c) ? c - 'a' + 1 : c - 'A' + 27 for c in line[1:N÷2]] |> unique
    comp2 = [islowercase(c) ? c - 'a' + 1 : c - 'A' + 27 for c in line[N÷2+1:end]] |> unique


    for i in comp1
        if i ∈ comp2
            priority += i
        end
    end
end
@show priority

lines = readlines("3/3.txt")
priority = 0
for i in 1:3:length(lines)
    elf1 = [islowercase(c) ? c - 'a' + 1 : c - 'A' + 27 for c in lines[i]] |> unique
    elf2 = [islowercase(c) ? c - 'a' + 1 : c - 'A' + 27 for c in lines[i+1]] |> unique
    elf3 = [islowercase(c) ? c - 'a' + 1 : c - 'A' + 27 for c in lines[i+2]] |> unique
    for i = 1:56
        if (count(==(i), vcat(elf1, elf2, elf3)) == 3)
            priority += i
            @show i
        end
    end
end
@show priority