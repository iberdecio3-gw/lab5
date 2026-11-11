args <- commandArgs(trailingOnly = TRUE)
combined <- read.csv(args[1])

counts <- rbind(combined$lab3_samples, combined$lab4_patients)
percentages <- 100 * sweep(counts, 1, rowSums(counts), "/")

png(args[2], width = 800, height = 500)
barplot(
  percentages,
  beside = TRUE,
  names.arg = combined$sex,
  col = c("steelblue", "darkorange"),
  legend.text = c("Lab 3 samples", "Lab 4 patients"),
  args.legend = list(x = "topright"),
  ylim = c(0, 100),
  ylab = "Percent within dataset",
  main = "Sex categories in Lab 3 and Lab 4"
)
dev.off()

writeLines(c(
  "# Lab 5 summary",
  "",
  sprintf("Lab 3 contributed %d samples.", sum(combined$lab3_samples)),
  sprintf("Lab 4 contributed %d patients.", sum(combined$lab4_patients)),
  "The workflow joined counts by sex category because the datasets have no shared patient ID."
), args[3])
