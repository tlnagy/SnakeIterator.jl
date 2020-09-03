using Documenter
using SnakeIterator
using Test

@testset "SnakeIterator.jl" begin
    doctest(SnakeIterator; manual = false)
end
