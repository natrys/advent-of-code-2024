macro do_if_unsafe(levels, dir, index, action)
  quote
    local diffs = diff($(esc(levels))) .* $(esc(dir))
    for $(esc(index)) in 1:length(diffs)
      let val = diffs[$(esc(index))]
        if val < 1 || val > 3
          $(esc(action))
        end
      end
    end
  end
end

function check_safety(levels)
  dir = levels[2] - levels[1] > 0 ? 1 : -1
  suspects = Int[]
  index = gensym()
  @do_if_unsafe levels dir index push!(suspects, index)
  if length(suspects) > 1
    for suspect in suspects
      @do_if_unsafe deleteat!(copy(levels), suspect) dir index @goto loop
      return true
      @label loop
    end
    return false
  end
  return true
end

function main()
  count = 0
  for line in eachline()
    levels = parse.(Int, split(line))
    count += check_safety(levels)
  end
  println(count)
end

@time main()
