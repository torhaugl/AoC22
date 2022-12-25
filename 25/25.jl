#   Decimal          SNAFU
#         1              1
#         2              2
#         3             1=
#         4             1-
#         5             10
#         6             11
#         7             12
#         8             2=
#         9             2-
#        10             20
#        15            1=0
#        20            1-0
#      2022         1=11-2
#     12345        1-0---0
# 314159265  1121-1110-1=0

function parse_input(fname)
    return readlines(fname)
end

function SNAFU2decimal(SNAFU)
    SNAFU_split = [string(c) for c in SNAFU]
    SNAFU_split = replace.(SNAFU_split, "=" => "-2", "-" => "-1")
    SNAFU_num = parse.(Int, SNAFU_split)
    Nmax = length(SNAFU_num) - 1
    return sum(5^n * SNAFU_num[end - n] for n = 0:Nmax)
end


function decimal2SNAFU(num)
    Nmax = 1
    num_max = SNAFU2decimal(prod(["2" for _ = 1:Nmax]))
    while num ∉ 0:num_max
        Nmax += 1
        num_max = SNAFU2decimal(prod(["2" for _ = 1:Nmax]))
    end

    # Initial guess
    SNAFU = prod("=" for _ = 1:Nmax)

    n_SNAFU2decimal_calls = 0
    for n = 1:Nmax
        cs = ['=', '-', '0', '1', '2']
        for (i, c) in enumerate(cs[2:end])
            SNAFU = SNAFU[1:n-1] * c * SNAFU[n+1:end]
            n_SNAFU2decimal_calls += 1
            dec = SNAFU2decimal(SNAFU) 
            if dec > num
                SNAFU = SNAFU[1:n-1] * cs[i] * SNAFU[n+1:end]
                break
            end
        end
    end

    @assert SNAFU2decimal(SNAFU) == num
    @show n_SNAFU2decimal_calls
    return SNAFU
end

part1 = parse_input("25/input.txt") .|> SNAFU2decimal |> sum |> decimal2SNAFU
