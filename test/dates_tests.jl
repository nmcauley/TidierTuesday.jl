using Test
using Dates

@testset "Dates functionality" begin

    @testset "get_last_tuesday" begin
        # Test with a known date
        test_date = Date(2024, 4, 15)  # Monday
        last_tuesday = get_last_tuesday(test_date)
        @test last_tuesday == Date(2024, 4, 9)
        
        # Test with a Tuesday
        test_date = Date(2024, 4, 9)  # Tuesday
        last_tuesday = get_last_tuesday(test_date)
        @test last_tuesday == Date(2024, 4, 9)
    end
end