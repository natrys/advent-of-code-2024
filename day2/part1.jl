function check_safety(levels)
  for i in levels
    if i < 1 || i > 3
      return false
    end
  end
  return true
end

function main()
  count = 0
  for line in eachline()
    levels = parse.(Int, split(line))
    levels = levels[1:end-1] - levels[2:end]
    dir = levels[1] > 0 ? 1 : -1
    levels .*= dir
    count += check_safety(levels)
  end
  println(count)
end

@time main()
