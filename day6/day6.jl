mutable struct Point
  row::UInt8
  col::UInt8
end

@enum Dir::UInt8 None Left Right Up Down

function main()
  mark(stdin)
  N = length(readline())
  reset(stdin)

  obstacles = fill(false, N, N)
  start = (0, 0)

  for (row, line) in enumerate(eachline())
    for (col, char) in enumerate(line)
      char == '^' && (start = (row, col))
      char == '#' && (obstacles[row, col] = true)
    end
  end

  function rotate(pos::Point, dir::Dir)::Dir
    if (dir == Up::Dir) return(pos.row > 1 && obstacles[pos.row-1, pos.col] ? Right::Dir : dir) end
    if (dir == Down::Dir) return(pos.row < N && obstacles[pos.row+1, pos.col] ? Left::Dir : dir) end
    if (dir == Left::Dir) return(pos.col > 1 && obstacles[pos.row, pos.col-1] ? Up::Dir : dir) end
    if (dir == Right::Dir) return(pos.col < N && obstacles[pos.row, pos.col+1] ? Down::Dir : dir) end
  end

  function move(pos::Point, dir::Dir)
    (dir == Up::Dir) && (pos.row -= 1; return;)
    (dir == Down::Dir) && (pos.row += 1; return;)
    (dir == Left::Dir) && (pos.col -= 1; return;)
    (dir == Right::Dir) && (pos.col += 1; return;)
  end

  function find_loop(obstacles::Matrix{Bool}, show_path = false)::Union{Matrix{Dir}, Bool}
    dir = Up::Dir
    pos = Point(start[1], start[2])
    visited = fill(None, N, N)
    while 1 <= pos.row <= N && 1 <= pos.col <= N
      visited[pos.row, pos.col] == dir && return true
      visited[pos.row, pos.col] = dir
      dir = rotate(pos, dir); dir = rotate(pos, dir)
      move(pos, dir)
    end
    show_path ? visited : false
  end

  first_run = find_loop(obstacles, true)
  println("Part1: $(count(v -> v != None, first_run))")

  first_run[start[1], start[2]] = None
  loops = 0
  for i in 1:N
    for j in 1:N
      if (first_run[i, j]) != None
        obstacles[i, j] = true
        loops += find_loop(obstacles, false)
        obstacles[i, j] = false
      end
    end
  end
  println("Part2: $loops")
end

@time main()
