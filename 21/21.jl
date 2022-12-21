# Fun and silly eval-solution
function part1_eval()
    lines = readlines("21/input.txt")
    lines = replace.(lines, ':'=>'=', '/' => '÷')
    skipped = 1
    while skipped > 0
        skipped = 0
        for line in lines
            try
                eval(Meta.parse(line))
            catch
                skipped += 1
            end
        end
        if skipped > 0
            println("SKIP $skipped / $(length(lines))")
        end
    end
    @show root
end

# Part 1 (less silly, but still not good)
function parse(fname)
    lines = readlines(fname)
    lines = replace.(lines, ':'=>'=', '/' => '÷')
    id = findfirst(x -> startswith(x, "root"), lines)
    root_line = popat!(lines, id)
    @show root_line
    root_line1 = root_line[7:10]
    root_line2 = root_line[14:17]
    return lines, root_line1, root_line2
end

function reduce_lines!(lines, root_line1, root_line2)
    todelete = Int[1]
    while !isempty(todelete)
        empty!(todelete)
        for (i, line) in enumerate(lines)
            m = match(r"(\w+)= (\d+ . \d+)", line)
            if m !== nothing
                push!(todelete, i)
                num = eval(Meta.parse(m.captures[2]))
                if m.captures[1] == root_line1 || m.captures[1] == root_line2
                    println("$(m.captures[1]) = $num")
                end
                lines = replace.(lines, m.captures[1]=> num)
            end

            m = match(r"\w+= \w+ . \w+", line)
            if m !== nothing
                continue
            end

            m = match(r"(\w+)= (\d+)", line)
            if m !== nothing
                push!(todelete, i)
                lines = replace.(lines, m.captures[1]=> m.captures[2])
            end
        end
        deleteat!(lines, todelete)
    end
    return lines
end

@time part1_eval()

@time begin
    lines, root_line1, root_line2 = parse("21/input.txt")
    reduce_lines!(lines, root_line1, root_line2)
end

# Part 2

# Reduce the amount of equations

lines, root_line1, root_line2 = parse("21/input.txt")
filter!(x -> !startswith(x, "humn"), lines)
push!(lines, "pnhm= zvcm + 0")
lines = reduce_lines!(lines, root_line1, root_line2)

# Invert relations and insert pnhm = zvcm = 32853424641061
lines = invert_relations!(lines)
lines = reduce_lines!(lines, "humn", "jjzz")
lines = invert_relations!(lines)

lines = ["abcd= 1234 + wxyz",
         "abcd= 1234 - wxyz",
         "abcd= 1234 * wxyz",
         "abcd= 1234 ÷ wxyz",
         "abcd= wxyz + 1234",
         "abcd= wxyz - 1234",
         "abcd= wxyz * 1234",
         "abcd= wxyz ÷ 1234"]

invert_relations!(lines)

function invert_relations!(lines)
    for (i, line) in enumerate(lines)
        m = match(r"(\w+)= (\d+) \+ (\w+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$c= $a - $b"
            continue
        end
        m = match(r"(\w+)= (\d+) \- (\w+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$c= $b - $a"
            continue
        end
        m = match(r"(\w+)= (\d+) \* (\w+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$c= $a ÷ $b"
            continue
        end
        m = match(r"(\w+)= (\d+) \÷ (\w+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$c= $b ÷ $a"
            continue
        end
        m = match(r"(\w+)= (\w+) \+ (\d+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$b= $a - $c"
            continue
        end
        m = match(r"(\w+)= (\w+) \- (\d+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$b= $a + $c"
            continue
        end
        m = match(r"(\w+)= (\w+) \* (\d+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$b= $a ÷ $c"
            continue
        end
        m = match(r"(\w+)= (\w+) \÷ (\d+)", line)
        if m !== nothing
            a, b, c = m.captures[1], m.captures[2], m.captures[3]
            lines[i] = "$b= $a * $c"
            continue
        end
    end
    return lines
end