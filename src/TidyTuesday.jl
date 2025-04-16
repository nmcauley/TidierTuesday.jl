module JuliaTuesday

using Dates
using HTTP
using JSON3
using DataFrames
using CSV

# Export public functions
export get_last_tuesday,
       list_datasets,
       download_file,
       download_dataset,
       show_readme,
       check_rate_limit

# Include sub-modules
include("dates.jl")
include("api.jl")
include("download.jl")

end # module 