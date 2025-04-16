# TidyTuesday.jl

TidyTuesday.jl is a Julia package that ports the functionality of the TidyTuesday CRAN package to Julia. It provides a suite of functions for accessing and downloading [TidyTuesday](https://github.com/rfordatascience/tidytuesday) datasets hosted on GitHub.

## Features

* **Get the most recent Tuesday date:** Useful for aligning with TidyTuesday releases
* **List available datasets:** Discover available TidyTuesday datasets across years
* **Download datasets:** Retrieve individual files or complete datasets
* **Display dataset README:** Open the dataset's README in your web browser
* **Check GitHub API rate limits:** Monitor your GitHub API usage

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

Here's a complete example of how to discover, download, and explore TidyTuesday data:

```julia
using TidyTuesday
using DataFrames
using CSV
using Plots

# 1. Find the most recent Tuesday date
tuesday = get_last_tuesday()
println("Most recent Tuesday: ", tuesday)

# 2. List all available datasets
all_datasets = list_datasets()
println("Total datasets available: ", length(all_datasets))

# 3. List datasets for a specific year
year_datasets = list_datasets(2025)
println("Datasets for 2025: ", length(year_datasets))

# 4. Download a specific file from a dataset
download_file("2025-03-11", "example.csv")

# 5. Read and analyze the data using Julia's DataFrames
df = CSV.read("example.csv", DataFrame)

# Display the first few rows
first(df, 5)

# Get basic information about the dataset
describe(df)

# Create a simple visualization
plot(df.x, df.y, 
     title="TidyTuesday Data Visualization",
     xlabel="X Axis",
     ylabel="Y Axis",
     seriestype=:scatter)
```

### Direct Data Loading

You can also read data directly from GitHub without downloading:

```julia
using HTTP
using CSV
using DataFrames

# Read a CSV file directly from GitHub
url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-03-18/palmtrees.csv"
df = CSV.read(HTTP.get(url).body, DataFrame)

# Analyze the data
first(df, 5)
```

## Dependencies

- Julia 1.6 or higher
- HTTP.jl
- JSON3.jl
- DataFrames.jl
- Dates (stdlib)

## License

This project is licensed under the MIT License - see the LICENSE file for details. 