lines = readlines("2/2.txt")
score = 0
for line in lines
    if line == "A X"
        score += 1
        score += 3
    elseif line == "A Y"
        score += 2
        score += 6
    elseif line == "A Z"
        score += 3
        score += 0
    elseif line == "B X"
        score += 1
        score += 0
    elseif line == "B Y"
        score += 2
        score += 3
    elseif line == "B Z"
        score += 3
        score += 6
    elseif line == "C X"
        score += 1
        score += 6
    elseif line == "C Y"
        score += 2
        score += 0
    elseif line == "C Z"
        score += 3
        score += 3
    end
end
@show score


lines = readlines("2/2.txt")
score = 0
for line in lines
    if line == "A X"
        score += 3
        score += 0
    elseif line == "A Y"
        score += 1
        score += 3
    elseif line == "A Z"
        score += 2
        score += 6
    elseif line == "B X"
        score += 1
        score += 0
    elseif line == "B Y"
        score += 2
        score += 3
    elseif line == "B Z"
        score += 3
        score += 6
    elseif line == "C X"
        score += 2
        score += 0
    elseif line == "C Y"
        score += 3
        score += 3
    elseif line == "C Z"
        score += 1
        score += 6
    end
end
@show score