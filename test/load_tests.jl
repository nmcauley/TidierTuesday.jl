using Test
using Dates

# Set up test environment
const TEST_CACHE_DIR = joinpath(@__DIR__, "test_cache")

@testset "Load functionality" begin

    # Create test fixture file
    test_file = joinpath(TEST_CACHE_DIR, "02-04-2024", "test_dataset.csv")
    mkpath(dirname(test_file))
    write(test_file, "col1,col2,col3\n1,2,3\n4,5,6\n7,8,9\n")

    @testset "tt_load" begin

        # verify default cache directory
        @test get_cache_dir() == joinpath(homedir(), ".tidytuesday", "cache")

        # set cache directory
        set_cache_dir(TEST_CACHE_DIR)
        @test get_cache_dir() == TEST_CACHE_DIR

        # Test loading a dataset
        tuple = tt_load("02-04-2024", use_cache=true)
        df = tuple.test_dataset

        # Test DataFrame structure
        @test nrow(df) == 3
        @test names(df) == ["col1", "col2", "col3"]

    end

    # Clean up test files
    rm(test_file)
    rm(joinpath(TEST_CACHE_DIR), recursive=true, force=true)
end