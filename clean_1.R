library(tidyverse)
library(lubridate)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
msydta <- read_csv(args[1])


#IDs
msydta$sample_id <- str_extract(msydta$sample_id, "\\d{4}")
msydta$sample_id <- paste0("S", msydta$sample_id)


#sex
msydta$sex <- str_to_lower(msydta$sex)
msydta$sex <- case_when(
  str_detect(msydta$sex, "^f$|female") ~ "Female",
  str_detect(msydta$sex, "^m$|male") ~ "Male",
  TRUE ~ "Unknown"
)


#site
msydta$enrollment_site <- str_to_lower(msydta$enrollment_site)

msydta$enrollment_site <- str_replace_all(
  msydta$enrollment_site,
  "[-_\\s]",
  ""
)

msydta$enrollment_site <- case_when(
  str_detect(msydta$enrollment_site, "^sitea$") ~ "Site A",
  str_detect(msydta$enrollment_site, "^siteb$") ~ "Site B",
  str_detect(msydta$enrollment_site, "^sitec$") ~ "Site C",
  TRUE ~ NA_character_
)


#date
msydta$dob <- parse_date_time(
  msydta$dob,
  orders = c("mdY", "Ymd", "dbY", "mdy")
)

msydta$dob <- format(msydta$dob, "%Y-%m-%d")


#glucose

#removing stars
msydta$glucose_flag <- str_detect(
  msydta$glucose_value,
  "\\*"
)
msydta$glucose_value <- str_replace_all(
  msydta$glucose_value,
  "\\*",
  ""
)

#making numeric
msydta$glucose_value <- as.numeric(msydta$glucose_value)


#standardize units
msydta$glucose_unit <- str_to_lower(msydta$glucose_unit)

mmol_rows <- str_detect(
  msydta$glucose_unit,
  "mmol/l"
)
# mmol/L -> mg/dL
msydta$glucose_value[mmol_rows] <-
  msydta$glucose_value[mmol_rows] * 18.0182

msydta$glucose_value <- round(msydta$glucose_value, 1)

msydta$glucose_unit <- "mg/dL"

print(head(msydta, 10))
#save
write_csv(
  msydta,
  args[2]
)
