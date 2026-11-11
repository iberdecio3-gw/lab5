library(dplyr)
library(readr)

args <- commandArgs(trailingOnly = TRUE)

standardize_sex <- function(sex) {
  sex <- tolower(trimws(sex))
  case_when(
    sex %in% c("f", "female") ~ "Female",
    sex %in% c("m", "male") ~ "Male",
    TRUE ~ "Unknown"
  )
}

samples <- read_csv(args[1], show_col_types = FALSE) %>%
  count(sex = standardize_sex(sex), name = "lab3_samples")

patients <- read_tsv(args[2], show_col_types = FALSE) %>%
  count(sex = standardize_sex(sex), name = "lab4_patients")

combined <- full_join(samples, patients, by = "sex") %>%
  mutate(
    lab3_samples = coalesce(lab3_samples, 0L),
    lab4_patients = coalesce(lab4_patients, 0L)
  )

write_csv(combined, args[3])