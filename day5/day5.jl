function main()
  rules = Dict{Int64, Set{Int64}}()
  for line in eachline()
    line == "" && break
    a, b = parse.(Int64, split(line, "|"))
    push!(get!(rules, a, Set{Int64}()), b)
  end

  part1, part2 = 0, 0
  for update in eachline()
    correct = true
    nums = parse.(Int64, split(update, ","))
    for i in 1:length(nums)-1
      for j in i:length(nums)
        !(haskey(rules, nums[j])) && continue
        if nums[i] in rules[nums[j]]
          correct = false
          insert!(nums, i, nums[j])
          deleteat!(nums, j+1)
        end
      end
    end
    mid = nums[div(length(nums), 2) + 1]
    correct ? part1 += mid : part2 += mid
  end

  print("Part1: $part1\nPart2: $part2\n")
end

@time main()
