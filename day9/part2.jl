@enum Type Skip File

mutable struct Block
  start::UInt
  size::UInt
  value::Int
  type::Type
end

checksum_block(block::Block) =
  sum((block.start + i - 1) * block.value for i in 1:block.size)

function main()
  input = parse.(Int, collect(readline("../inputs/day9")))

  blocks::Vector{Block} = []
  start = 0
  for i in eachindex(input)
    input[i] == 0 && continue
    if i % 2 == 1
      push!(blocks, Block(start, input[i], i >> 1, File::Type))
    else
      push!(blocks, Block(start, input[i], 0, Skip::Type))
    end
    start += input[i]
  end

  right_index = length(blocks)
  while right_index > 1
    if blocks[right_index].type == File
      right = blocks[right_index]
      for left_index in 1:right_index-1
        if blocks[left_index].type == Skip
          left = blocks[left_index]
          if left.size >= right.size
            if left.size > right.size
              right.start = left.start
              left.start += right.size
              left.size -= right.size
            else
              # they are equal size, so left can just become right and vice versa
              left.value = right.value
              left.type = File
              right.type = Skip
            end
            break
          end
        end
      end
    end
    right_index -= 1
  end

  checksum = 0
  for block in blocks
    if block.type == File
      checksum += checksum_block(block)
    end
  end

  println("Part2: $checksum")
end

@time main() # 40ms on my input
