module SnakeIterator

export snake

struct SnakeIter{R <: AbstractMatrix{T} where {T}}
    arr::R
end

"""
    snake(arr)
    
Creates a snaking iterator of the given 2D array `arr`, i.e. it traverses even
columns in reverse to form a continuous S shape through the array. Transform
`arr` with `permutedims` to snake along rows instead.

#### Simple case

```jldoctest example1
julia> using SnakeIterator

julia> arr = reshape(1:16, 4, 4)
4×4 reshape(::UnitRange{Int64}, 4, 4) with eltype Int64:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> s = collect(snake(arr)); # snake over collection

julia> reshape(s, 4, 4) # notice that the even columns are now reversed
4×4 Array{Int64,2}:
 1  8   9  16
 2  7  10  15
 3  6  11  14
 4  5  12  13
```
#### Looping over snaked rows

```jldoctest example1
julia> println([i for i in snake(permutedims(arr))]) # visits in row-major order
[1, 5, 9, 13, 14, 10, 6, 2, 3, 7, 11, 15, 16, 12, 8, 4]

```
"""
snake(arr) = SnakeIter(arr)

function Base.iterate(iter::SnakeIter, state = 1)

    if state > length(iter)
        return nothing
    end

    collength = size(iter.arr, 1)

    if iseven((state - 1) ÷ collength + 1) # is column even
        # flip the iteration
        flipped = ceil(Int, state/collength) * collength - mod1(state, collength) + 1
        res = iter.arr[flipped]
    else
        res = iter.arr[state]
    end

    return (res, state + 1)
end

Base.length(iter::SnakeIter) = length(iter.arr)

Base.eltype(iter::SnakeIter) = eltype(iter.arr)

end
