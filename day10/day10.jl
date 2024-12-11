function main()
  starts = Vector{Complex}()
  grid = Dict{Complex,UInt8}()

  for (row, line) in enumerate(eachline())
    for (col, char) in enumerate(line)
      grid[complex(row, col)] = UInt8(char - '0')
      char == '0' && push!(starts, complex(row, col))
    end
  end

  visited = Set{Complex}()
  function solve(pos::Complex, part::Int)::Int
    grid[pos] == 9 && return 1

    solutions = 0
    for offset in [1 + 0im, -1 + 0im, 0 + 1im, 0 - 1im]
      next = pos + offset
      if haskey(grid, next) && grid[next] == grid[pos] + 1
        part == 1 && next in visited ? continue : push!(visited, next)
        solutions += solve(next, part)
      end
    end
    return solutions
  end

  part1, part2 = 0, 0
  for start in starts
    empty!(visited)
    part1 += solve(start, 1)
    part2 += solve(start, 2)
  end
  println("Part1: $part1")
  println("Part2: $part2")
end

@time main()
