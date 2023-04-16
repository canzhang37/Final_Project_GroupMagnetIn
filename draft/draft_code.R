library(httr)
library(readr)
# Replace this with your API URL
api_url <- "https://chronicdata.cdc.gov/resource/475u-gzzh.csv"

# Make the API request
response <- httr::GET(api_url)

# Check if the request was successful
if (httr::status_code(response) == 200) {
  # Read the CSV data from the response
  data <- read_csv(httr::content(response, "text", encoding = "UTF-8"))
  
  # View the first few rows of the data
  head(data)
} else {
  cat("Error:", httr::status_code(response), "\n")
}
