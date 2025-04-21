# Download a specific file from a dataset
function download_file(date_str::AbstractString, filename::AbstractString, target_path::AbstractString=filename)
    year = split(date_str, "-")[1]
    url = "$RAW_CONTENT_URL/data/$year/$date_str/$filename"
    
    try
        response = HTTP.get(url)
        open(target_path, "w") do io
            write(io, response.body)
        end
        return true
    catch e
        @error "Failed to download file" date_str filename exception=e
        return false
    end
end

# Download all files from a dataset
function download_dataset(date_str::AbstractString)
    files = get_dataset_files(date_str)
    
    successful = []
    failed = []
    
    for file in files
        if download_file(date_str, file.name)
            push!(successful, file.name)
        else
            push!(failed, file.name)
        end
    end
    
    return (successful=successful, failed=failed)
end

# Show README in default browser
function show_readme(date_str::AbstractString)
    url = get_readme_url(date_str)
    
    # Different commands for different operating systems
    cmd = if Sys.isapple()
        `open $url`
    elseif Sys.islinux()
        `xdg-open $url`
    elseif Sys.iswindows()
        `cmd /c start $url`
    else
        error("Unsupported operating system")
    end
    
    try
        run(cmd)
        return true
    catch e
        @error "Failed to open README in browser" exception=e
        return false
    end
end 