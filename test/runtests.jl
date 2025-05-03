using TidierTuesday
using Test
using DataFrames
using CSV
using Dates

@testset "TidierTuesday.jl" begin

    @testset "Dates" begin
        include("dates_tests.jl")
    end

    @testset "Load" begin
        include("load_tests.jl")
    end
end