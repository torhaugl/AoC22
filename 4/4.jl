count_elfs = 0
for line in eachline("4/4.txt")
    r = eachmatch(r"(\d+)", line) |> collect
    a = parse(Int, r[1].match)
    b = parse(Int, r[2].match)
    c = parse(Int, r[3].match)
    d = parse(Int, r[4].match)
    elf1 = a:b
    elf2 = c:d
    if a >= c && b <= d
        count_elfs += 1
    elseif c >= a && d <= b
        count_elfs += 1
    end
end
@show count_elfs

count_elfs = 0
for line in eachline("4/4.txt")
    r = eachmatch(r"(\d+)", line) |> collect
    a = parse(Int, r[1].match)
    b = parse(Int, r[2].match)
    c = parse(Int, r[3].match)
    d = parse(Int, r[4].match)
    elf1 = a:b
    elf2 = c:d
    for i in elf1
        if i ∈ elf2
            count_elfs += 1
            break
        end
    end
end
@show count_elfs