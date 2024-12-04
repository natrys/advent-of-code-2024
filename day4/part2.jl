function main()
  elems = ['M', 'S']
  points = Dict()
  starts = []

  for (row, line) in enumerate(eachline())
    for (col, char) in enumerate(line)
      char in elems && (points[[row, col]] = char)
      char == 'A' && push!(starts, [row, col])
    end
  end

  check(p1, p2) = begin
    c1 = get(points, p1, ' '); c2 = get(points, p2, ' ')
    c1 == 'M' && c2 == 'S' || c1 == 'S' && c2 == 'M'
  end
  
  println(sum(check(a + [1, 1], a + [-1, -1]) && check(a + [1, -1], a + [-1, 1]) for a in starts))
end

main()
