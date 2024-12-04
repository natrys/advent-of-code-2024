offsets = [[i, j] for i in -1:1 for j in -1:1 if i != 0 || j != 0]

function main()
  elems = ['M', 'A', 'S']
  points = Dict()
  starts = []

  for (row, line) in enumerate(eachline())
    for (col, char) in enumerate(line)
      char in elems && (points[[row, col]] = char)
      char == 'X' && push!(starts, [row, col])
    end
  end

  count = 0
  for x in starts
    for o in offsets
      pos = x
      for i in 1:3
        pos += o
        if get(points, pos, ' ') != elems[i] @goto loop end
      end
      count += 1
      @label loop
    end
  end

  println(count)
end

main()
