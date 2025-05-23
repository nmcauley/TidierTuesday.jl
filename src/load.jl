# Default cache directory in home folder
const DEFAULT_CACHE_DIR = joinpath(homedir(), ".tidytuesday", "cache")

# Allow override via environment variable
global CACHE_DIR = get(ENV, "TIDYTUESDAY_CACHE_DIR", DEFAULT_CACHE_DIR)

const CACHE_VERSION = 1  # Increment this when cache format changes

"""
    set_cache_dir(path::AbstractString)

Set the cache directory for TidyTuesday datasets. This will be used for all future
caching operations.

# Arguments
- `path`: The path to use for caching datasets
"""
function set_cache_dir(path::AbstractString)
    global CACHE_DIR
    CACHE_DIR = path
    mkpath(CACHE_DIR)  # Create the directory if it doesn't exist
    return CACHE_DIR
end

"""
    get_cache_dir()

Get the current cache directory path.
"""
function get_cache_dir()
    return CACHE_DIR
end

"""
    tt_load(date::Union{String,Date}; use_cache=true)

Load TidyTuesday datasets for a specific date. Returns a NamedTuple of DataFrames.

# Arguments
- `date`: Either a date string in "YYYY-MM-DD" format or a Date object
- `use_cache`: Whether to use cached data if available (default: true)

# Returns
A NamedTuple where each field is a DataFrame containing the dataset.

"""
function tt_load(date::Union{String,Date}; use_cache=true)
    date_str = date isa Date ? Dates.format(date, "yyyy-mm-dd") : date
    
    # Create cache directory if it doesn't exist
    mkpath(CACHE_DIR)
    
    # Create date-specific cache directory
    date_cache_dir = joinpath(CACHE_DIR, date_str)
    
    if use_cache && isdir(date_cache_dir)
        # Try loading from cache first
        datasets = NamedTuple()
        for file in readdir(date_cache_dir)
            if endswith(lowercase(file), ".csv")
                name = Symbol(splitext(file)[1])
                df = CSV.read(joinpath(date_cache_dir, file), DataFrame)
                datasets = merge(datasets, NamedTuple{(name,)}((df,)))
            end
        end
        if !isempty(datasets)
            return datasets
        end
    end
    
    # If we get here, either cache is disabled or files weren't found
    files = get_dataset_files(date_str)
    
    # Create a temporary directory for downloads
    temp_dir = mktempdir()
    
    # Download and load each file
    datasets = NamedTuple()
    for file in files
        if endswith(lowercase(file.name), ".csv")
            # Download to temp directory
            temp_file = joinpath(temp_dir, file.name)
            download_file(date_str, file.name, temp_file)
            
            # Load into DataFrame
            df = CSV.read(temp_file, DataFrame)
            
            # Add to datasets NamedTuple
            name = Symbol(splitext(file.name)[1])
            datasets = merge(datasets, NamedTuple{(name,)}((df,)))
            
            # Cache the CSV if caching is enabled
            if use_cache
                mkpath(date_cache_dir)
                cp(temp_file, joinpath(date_cache_dir, file.name), force=true)
            end
        end
    end
    
    println("Cleanup temp dir: ", temp_dir)
    # Clean up temp directory
    rm(temp_dir, recursive=true)
    
    return datasets
end

"""
    tt_load(year::Integer, week::Integer; use_cache=true)

Load TidyTuesday datasets for a specific year and week. Returns a NamedTuple of DataFrames.

# Arguments
- `year`: The year (e.g., 2024)
- `week`: The week number (1-52)
- `use_cache`: Whether to use cached data if available (default: true)

# Returns
A NamedTuple where each field is a DataFrame containing the dataset.
"""
function tt_load(year::Integer, week::Integer; use_cache=true)
    # Find the date for this year/week
    datasets = list_datasets(year)
    if isempty(datasets)
        error("No datasets found for year $year")
    end
    
    # Sort by date and get the requested week
    sorted_dates = sort(datasets, by=x -> x.date)
    if week < 1 || week > length(sorted_dates)
        error("Week $week is out of range for year $year (1-$(length(sorted_dates)))")
    end
    
    date_str = sorted_dates[week].date
    return tt_load(date_str, use_cache=use_cache)
end 