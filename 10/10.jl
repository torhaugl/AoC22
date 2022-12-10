lines = readlines("10/input.txt")

cycle = 0
X = 1
signal = 0
measurings_times = [20, 60, 100, 140, 180, 220]
screen = zeros(Int, 6*40) # (6, 40)

for line in lines
    if startswith(line, "noop")
        cycle += 1
        screen[cycle] = (cycle-1) % 40 ∈ X-1:X+1
        if (cycle ∈ measurings_times) signal += cycle * X end
    elseif startswith(line, "addx")
        n = parse(Int, split(line)[2])
        for i = 1:2
            cycle += 1
            screen[cycle] = (cycle-1) % 40 ∈ X-1:X+1
            if (cycle ∈ measurings_times) signal += cycle * X end
        end
        X += n
    end
end

@show signal

using Plots
image = reshape(screen, (40, 6))'
heatmap(image, yflip=true)