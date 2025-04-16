# Get the most recent Tuesday relative to a given date
function get_last_tuesday(date::Date=today())
    # Calculate days since last Tuesday (Tuesday is 2 in Julia's dayofweek)
    days_since = mod(dayofweek(date) - 2, 7)
    return date - Day(days_since)
end

# Format date for TidyTuesday API calls
function format_tt_date(date::Date)
    return Dates.format(date, "yyyy-mm-dd")
end

# Parse TidyTuesday date string to Date object
function parse_tt_date(date_str::AbstractString)
    return Date(date_str, "yyyy-mm-dd")
end 