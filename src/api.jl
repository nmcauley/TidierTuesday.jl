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
    if year === nothing
        # Get the contents of the data directory
        url = "$API_BASE_URL/repos/$TIDYTUESDAY_REPO/contents/data"
        response = HTTP.get(url)
        years = JSON3.read(response.body)
        
        all_datasets = []
        
        # Iterate through each year
        for year_dir in years
            if year_dir.type == "dir"
                year_datasets = list_datasets(parse(Int, year_dir.name))
                for dataset in year_datasets
                    push!(all_datasets, (
                        year = year_dir.name,
                        date = dataset.date,
                        path = dataset.path,
                        url = dataset.url
                    ))
                end
            end
        end
        
        return sort(all_datasets, by = x -> (x.year, x.date))
    else
        # Get the contents of the data directory for the specified year
        url = "$API_BASE_URL/repos/$TIDYTUESDAY_REPO/contents/data/$year"
        response = HTTP.get(url)
        contents = JSON3.read(response.body)
        
        # Filter and format the dataset information
        datasets = []
        for item in contents
            if item.type == "dir"
                push!(datasets, (
                    date = item.name,
                    path = item.path,
                    url = item.url
                ))
            end
        end
        
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
