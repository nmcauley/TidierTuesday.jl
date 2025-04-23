const TIDYTUESDAY_REPO = "rfordatascience/tidytuesday"
const API_BASE_URL = "https://api.github.com"
const RAW_CONTENT_URL = "https://raw.githubusercontent.com/$TIDYTUESDAY_REPO/refs/heads/main"

# Check GitHub API rate limit
function check_rate_limit()
    response = HTTP.get("$API_BASE_URL/rate_limit")
    limits = JSON3.read(response.body)
    return limits.resources.core
end

# List available datasets, optionally filtered by year
function list_datasets(year::Union{Integer, Nothing}=nothing)
    # Helper function to create dataset info
    function create_dataset_info(item, year_info=nothing)
        base_info = (
            date = item.name,
            path = item.path,
            url = item.url
        )

        return year_info === nothing ? base_info : 
            merge(base_info, (year = year_info,))
    end

    # Helper function to fetch and parse GitHub contents
    function fetch_contents(path)
        url = "$API_BASE_URL/repos/$TIDYTUESDAY_REPO/contents/$path"
        response = HTTP.get(url)
        return JSON3.read(response.body)
    end

    if year === nothing
        # Get all years
        years = fetch_contents("data")
        
        # Collect datasets from all years
        all_datasets = [(
            year = year_dir.name,
            dataset_info...
        ) for year_dir in years
          if year_dir.type == "dir"
          for dataset_info in list_datasets(parse(Int, year_dir.name))]
        
        return sort(all_datasets, by = x -> (x.year, x.date))
    else
        # Get specific year's datasets
        contents = fetch_contents("data/$year")
        
        # Filter directories and create dataset info
        datasets = [create_dataset_info(item) 
                   for item in contents 
                   if item.type == "dir"]
        
        return sort(datasets, by = x -> x.date)
    end
end

# Get README URL for a specific dataset
function get_readme_url(date_str::AbstractString)
    year = split(date_str, "-")[1]
    return "$RAW_CONTENT_URL/data/$year/$date_str/readme.md"
end

# Get file list for a specific dataset
function get_dataset_files(date_str::AbstractString)
    year = split(date_str, "-")[1]
    url = "$API_BASE_URL/repos/$TIDYTUESDAY_REPO/contents/data/$year/$date_str"
    
    response = HTTP.get(url)
    contents = JSON3.read(response.body)
    
    # Filter out README and return file information
    return filter(item -> item.type == "file" && !endswith(item.name, "README.md"), contents)
end 
