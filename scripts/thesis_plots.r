setwd('//wsl$/Ubuntu/home/sebas/bachelor-thesis/data/')

outpath = function(name) {
  return(paste("../images/", name, sep = ""))
};

startImage = function(name) {
  postscript(outpath(name), width = 4, height = 3, horizontal = FALSE)
  par(mgp=c(0.5,1,0), mar=c(3.9,3.8,1,0))
  par(lwd = 0.2)
};

endImage = function() {
  dev.off()
};

find_percentage_of_edits = function(solution_sizes, data) {
  files = c()
  percentages = c()
  for (i in 1:length(solution_sizes[,1])) {
    filename = solution_sizes[,1][i]
    sol_size = solution_sizes[,2][i]
    edits_from_red = data$edits[match(filename, data$file)]
    files = append(files, filename)
    percentages = append(percentages, edits_from_red / sol_size * 100)
  }
  return(data.frame(file=files, percent=percentages))
};

COL_ORIG = rgb(247, 126, 37, 255, maxColorValue = 255) #"red"
COL_REDUCED = rgb(45, 198, 213, 255, maxColorValue = 255) #"green"
COL_PERCENT = rgb(45, 198, 213, 255, maxColorValue = 255) #"green"

solution_sizes = read.table('solution_sizes', header = TRUE, skip = 1, sep = "|")

# ===== Critical Cliques =====
data = read.table('reduction/crit_cliques', header = TRUE, sep = "|", skip = 3)

# Overlaid original and reduced size
startImage("crit_cliques_absolute.eps")
barplot(data[, "before"], col = COL_ORIG, ylim = c(0, 620), ylab = "Vertex Count\n\n", xlab = "Instance")
barplot(data[, "after"], col = COL_REDUCED, add = TRUE)
legend(x = 0, y = 600, c("original", "reduced"), col=c(COL_ORIG, COL_REDUCED), pch=c(15,15))
endImage()

# % Reduction
startImage("crit_cliques_percent.eps")
percent_reduced = (data[, "before"] - data[, "after"]) / data[, "before"] * 100
barplot(percent_reduced, col = COL_PERCENT, ylim = c(0, 100), ylab = "% Reduction\n\n", xlab = "Instance")
endImage()

# ===== Rules 1 - 5 =====
data = read.table('reduction/rules1-5', header = TRUE, sep = "|", skip = 3)

# Overlaid original and reduced size
startImage("rules1-5_absolute.eps")
barplot(data[, "before"], col = COL_ORIG, ylim = c(0, 620), ylab = "Vertex Count\n\n", xlab = "Instance")
barplot(data[, "after"], col = COL_REDUCED, add = TRUE)
legend(x = 0, y = 600, c("original", "reduced"), col=c(COL_ORIG, COL_REDUCED), pch=c(15,15))
endImage()

# % Reduction
startImage("rules1-5_percent.eps")
percent_reduced = (data[, "before"] - data[, "after"]) / data[, "before"] * 100
barplot(percent_reduced, col = COL_PERCENT, ylim = c(0, 100), ylab = "% Reduction\n\n", xlab = "Instance")
endImage()

# ===== Full Initial Reduction =====
data = read.table('reduction/full_initial', header = TRUE, sep = "|", skip = 3)

# Overlaid original and reduced size
startImage("full_initial_absolute.eps")
barplot(data[, "before"], col = COL_ORIG, ylim = c(0, 620), ylab = "Vertex Count\n\n", xlab = "Instance")
barplot(data[, "after"], col = COL_REDUCED, add = TRUE)
legend(x = 0, y = 600, c("original", "reduced"), col=c(COL_ORIG, COL_REDUCED), pch=c(15,15))
endImage()

# % Reduction
startImage("full_initial_percent.eps")
percent_reduced = (data[, "before"] - data[, "after"]) / data[, "before"] * 100
barplot(percent_reduced, col = COL_PERCENT, ylim = c(0, 100), ylab = "% Reduction\n\n", xlab = "Instance")
endImage()

# ===== % of edits =====
data = read.table('reduction/full_initial', header = TRUE, sep = "|", skip = 3)

# for full reduction
percentages = find_percentage_of_edits(solution_sizes, data)
startImage("percent_edits_full.eps")
barplot(percentages[, "percent"], col = COL_PERCENT, ylim = c(0, 100), ylab = "% of edits\n\n", xlab = "Instance")
endImage()

data = read.table('reduction/rules1-5', header = TRUE, sep = "|", skip = 3)

# for only rules 1 - 5
percentages = find_percentage_of_edits(solution_sizes, data)
startImage("percent_edits_rules1-5.eps")
barplot(percentages[, "percent"], col = COL_PERCENT, ylim = c(0, 100), ylab = "% of edits\n\n", xlab = "Instance")
endImage()


# ===== Interleaved Effectiveness =====
data = read.table('reduction/interleaved_combined', header = TRUE, sep = "|")

# Convert each row from absolute values to percentages
for (row in 1:nrow(data)) {
  total = 0.0
  for (col in 2:ncol(data)) { # skip 'file' column
    total = total + data[row, col]
  }
  for (col in 2:ncol(data)) {
    data[row, col] = data[row, col] / total * 100
  }
}

averages = data.frame(source = colnames(data)[-1], avg = rep(0, ncol(data) - 1))
for (row in 1:nrow(data)) {
  for (col in 2:ncol(data)) {
    averages[col - 1, 2] = averages[col - 1, 2] + data[row, col] / nrow(data)
  }
}

startImage("interleaved_effectiveness.eps")
par(mgp=c(0.5,1,0), mar=c(5.9,3.8,1,0))
barplot(averages[1:6, "avg"], names.arg = averages[1:6, "source"], las = 2, 
        col = COL_PERCENT, ylim = c(0, 100), ylab = "% of reduction in k\n\n")
endImage()

# ===== Instance + Solution Sizes =====
instance_sizes = read.table('instance_sizes', header = TRUE, skip = 0, sep = "|")
instance_sizes$edits = rep(0, nrow(instance_sizes))
instance_sizes_only_solved = instance_sizes
for (i in 1:nrow(instance_sizes)) {
  instance = instance_sizes[,1][i]
  edits = solution_sizes$edits[match(instance, solution_sizes$file)]
  instance_sizes[,3][i] = edits
  
  if (is.na(edits)) {
    instance_sizes_only_solved[,2][i] = 0
  }
}

startImage("instances.eps")
barplot(instance_sizes$vertex.count, col = COL_ORIG, ylim = c(0, 620), ylab = "Vertex Count\n\n", xlab = "Instance")
barplot(instance_sizes_only_solved$vertex.count, col = COL_REDUCED, ylim = c(0, 620), add = T, axisnames=F, axes=F)
legend(x = 0, y = 600, c("solved", "unsolved"), col=c(COL_REDUCED, COL_ORIG), pch=c(15,15))
endImage()

startImage("solution_sizes.eps")
barplot(solution_sizes$edits, col = COL_REDUCED, ylim = c(0, 3000), ylab = "Edits\n\n", xlab = "Instance")
endImage()
