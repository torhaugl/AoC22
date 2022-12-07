# Use tree with Tuples of (String, Int, Vector{Tuple})

path = ""
files = []
dirs = []
for line in eachline("7/input.txt")
    #println(line)
    if line[1:4] == "\$ cd"
        #println(line)
        if line[1:6] == "\$ cd ."
            n = length(split(path, '/')[end-1])
            path = path[1:end-n-1]
        else
            dirname = split(line)[3]
            if (dirname[1] == '/') 
               path = dirname
            else 
               path = path * dirname * "/"
            end
            push!(dirs, path)
        end
    elseif line[1:4] == "\$ ls"
        #println(line)
        @show path
        list = []
    elseif line[1:3] == "dir"
        println(line)
        _, name = split(line)
        push!(dirs, path * name * "/")
    else # file
        println(line)
        siz, name = split(line)
        siz = parse(Int, siz)
        push!(files, (path * name, siz))
    end
end
files
dirs = unique(dirs)

sizes = Dict{String, Int}(dir => 0 for dir in dirs)
for dir in dirs, (fname, size) in files
    if length(fname) < length(dir)
        continue
    end

    if dir == fname[1:length(dir)]
        sizes[dir] += size
    end
end
sizes

t = 0
for v in values(sizes)
    if v <= 100_000
        t += v
    end
end
t

space = 40_000_000 - sizes["/"]

keyss = findall(>=(3956976), sizes)
[sizes[key] for key in keyss]