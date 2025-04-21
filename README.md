# TidyTuesday.jl

TidyTuesday.jl is a Julia package that ports the functionality of the TidyTuesday CRAN package to Julia. It provides a suite of functions for accessing and downloading [TidyTuesday](https://github.com/rfordatascience/tidytuesday) datasets hosted on GitHub.

## Features

* **Direct dataset loading:** Load datasets directly as DataFrames with automatic caching
* **Get the most recent Tuesday date:** Useful for aligning with TidyTuesday releases
* **List available datasets:** Discover available TidyTuesday datasets across years
* **Download datasets:** Retrieve individual files or complete datasets
* **Display dataset README:** Open the dataset's README in your web browser
* **Check GitHub API rate limits:** Monitor your GitHub API usage
* **Configurable caching:** Control where and how datasets are cached

## Installation

You can install TidyTuesday.jl using Julia's package manager. From the Julia REPL:

```julia
using Pkg
Pkg.add("TidyTuesday")
```

Or in pkg mode (press `]` in the REPL):

```julia
pkg> add TidyTuesday
```

## Usage

Once you have installed the package, you can start using it:

```julia
using TidyTuesday
```

### Loading Datasets

The main function for loading datasets is `tt_load`. It returns a NamedTuple of DataFrames:

```julia
# Load by date
data = tt_load("2024-04-16")
# Access datasets like:
data.dataset1
data.dataset2

# Or load by year and week
data = tt_load(2024, 16)  # 16th week of 2024
```

By default, datasets are cached to avoid repeated downloads. You can disable caching with:

```julia
data = tt_load("2024-04-16", use_cache=false)
```

### Cache Configuration

By default, datasets are cached in `~/.tidytuesday/cache`. You can configure the cache location in several ways:

1. **Environment Variable**: Set the `TIDYTUESDAY_CACHE_DIR` environment variable:
   ```bash
   # In your shell
   export TIDYTUESDAY_CACHE_DIR="/path/to/cache"
   ```

2. **Runtime Configuration**: Use the `set_cache_dir` function:
   ```julia
   # Set cache to a project-specific directory
   set_cache_dir(joinpath(pwd(), ".tidytuesday", "cache"))
   
   # Set cache to a custom location
   set_cache_dir("/path/to/cache")
   ```

3. **Check Current Cache Location**:
   ```julia
   cache_path = get_cache_dir()
   println("Using cache at: $cache_path")
   ```

### Basic Functions

* **Last Tuesday**
  * **Description:** Get the most recent Tuesday date relative to today's date or an optionally provided date
  * **Usage:**
  ```julia
  last_tuesday = get_last_tuesday()  # Returns current week's Tuesday
  last_tuesday = get_last_tuesday(Date(2025, 3, 10))  # Returns nearest Tuesday to specified date
  ```

* **List Available Datasets**
  * **Description:** Lists all available TidyTuesday datasets, optionally filtered by year
  * **Usage:**
  ```julia
  # List all datasets across all years
  all_datasets = list_datasets()
  
  # List datasets for a specific year
  year_datasets = list_datasets(2025)
  ```

* **Download Specific File**
  * **Description:** Downloads a specified file from a TidyTuesday dataset by date
  * **Usage:**
  ```julia
  download_file("2025-03-10", "data.csv")
  ```

* **Download Dataset Files**
  * **Description:** Downloads all or selected files from a TidyTuesday dataset by date
  * **Usage:**
  ```julia
  download_dataset("2025-03-10")  # Downloads all files
  download_dataset("2025-03-10", ["data.csv", "summary.json"])  # Downloads specific files
  ```

* **Display Dataset README**
  * **Description:** Opens the README for a TidyTuesday dataset in your default web browser
  * **Usage:**
  ```julia
  show_readme("2025-03-10")
  ```

* **Check GitHub Rate Limit**
  * **Description:** Checks the remaining GitHub API rate limit
  * **Usage:**
  ```julia
  check_rate_limit()
  ```

## Example Workflows

### Basic Workflow

Here's a complete example of how to discover and analyze TidyTuesday data:

```julia
using TidyTuesday
using DataFrames
using Plots

# 1. Find the most recent Tuesday date
tuesday = get_last_tuesday()
println("Most recent Tuesday: ", tuesday)

# 2. Load the dataset directly as DataFrames
data = tt_load(tuesday)

# 3. Access and analyze the datasets
for (name, df) in pairs(data)
    println("\nDataset: $name")
    println(describe(df))
    
    # Create a simple visualization if appropriate
    if ncol(df) >= 2
        plot(df[!, 1], df[!, 2], 
            title="TidyTuesday Data Visualization - $name",
            xlabel=names(df)[1],
            ylabel=names(df)[2],
            seriestype=:scatter)
    end
end
```

### Project-Specific Cache Example

If you want to keep the cache within your project directory:

```julia
using TidyTuesday

# Set up project-specific cache
set_cache_dir(joinpath(pwd(), ".tidytuesday", "cache"))

# Load and analyze data
data = tt_load("2024-04-16")
# ... work with data ...
```

### Manual Download Workflow

If you prefer to download and work with files directly:

```julia
using TidyTuesday
using DataFrames
using CSV

# Download a specific file
download_file("2024-04-16", "data.csv")

# Read and analyze the data
df = CSV.read("data.csv", DataFrame)
describe(df)
```

## Dependencies

- Julia 1.6 or higher
- HTTP.jl
- JSON3.jl
- DataFrames.jl
- CSV.jl
- Dates (stdlib)
- Serialization (stdlib)

## License

This project is licensed under the MIT License - see the LICENSE file for details. 