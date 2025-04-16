using Test
using JuliaTuesday
using Dates
using Pkg

# 1. First, activate the package in development mode
# Pkg.develop(path=".")  # Assuming you're in the JuliaTuesday directory
# using JuliaTuesday

# 2. Test get_last_tuesday
println("\n=== Testing get_last_tuesday ===")
today_tuesday = get_last_tuesday()
println("Last Tuesday from today: ", today_tuesday)
specific_tuesday = get_last_tuesday(Date(2024, 3, 15))  # A Friday
println("Last Tuesday from 2024-03-15: ", specific_tuesday)

# 3. Test list_datasets
println("\n=== Testing list_datasets ===")
# Test listing all datasets
println("Getting all datasets...")
all_datasets = list_datasets()
println("Total datasets found: ", length(all_datasets))
if !isempty(all_datasets)
    println("First dataset: ", first(all_datasets))
end

# Test listing datasets for a specific year
println("\nGetting datasets for 2024...")
year_datasets = list_datasets(2024)
println("Total 2024 datasets found: ", length(year_datasets))
if !isempty(year_datasets)
    println("First 2024 dataset: ", first(year_datasets))
end

# 4. Test downloading a file
println("\n=== Testing download_file ===")
# Use a dataset we found from list_datasets
if !isempty(year_datasets)
    test_date = year_datasets[1].date
    println("Attempting to download from date: ", test_date)
    success = download_file(test_date, "data.csv")
    println("Download success: ", success)
    if success
        println("File exists: ", isfile("data.csv"))
    end
end

# 5. Test downloading entire dataset
println("\n=== Testing download_dataset ===")
if !isempty(year_datasets)
    test_date = year_datasets[1].date
    println("Attempting to download all files from date: ", test_date)
    result = download_dataset(test_date)
    println("Successfully downloaded: ", length(result.successful), " files")
    println("Failed to download: ", length(result.failed), " files")
end

# 6. Test showing README
println("\n=== Testing show_readme ===")
if !isempty(year_datasets)
    test_date = year_datasets[1].date
    println("Attempting to open README for date: ", test_date)
    success = show_readme(test_date)
    println("README opened successfully: ", success)
end

# 7. Test rate limit
println("\n=== Testing check_rate_limit ===")
rate_limit = check_rate_limit()
println("Current rate limit: ", rate_limit) 