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
  input = parse.(Int, collect(readline()))

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

  checksum = 0
  while true
    iszero(length(blocks)) && break
    length(blocks) == 1 && blocks[1].type == Skip && break

    left = blocks[1]
    if left.type == File
      checksum += checksum_block(left)
      popfirst!(blocks)
    else
      # This part is a shit show
      while blocks[end].type == Skip
        pop!(blocks)
      end

      right = blocks[end]
      if right.size >= left.size
        # Left will be fully consumed
        left.value = right.value
        checksum += checksum_block(left)
        popfirst!(blocks)
        if right.size > left.size
          # But there is residual right here
          right.size = right.size - left.size
        else
          # Otherwise right is also consumed because left and right have same size
          pop!(blocks)
        end
      else
        # left.size > right.size, so there should be residual left, and right should be consumed
        checksum += checksum_block(Block(left.start, right.size, right.value, File))
        left.start += right.size
        left.size -= right.size
        pop!(blocks)
      end
    end
  end

  println("Part1: $checksum")
end

@time main() # 7ms on my input
