library(xlsx); library(caret)

data <- read.xlsx("training_set_rel3.xls", sheetIndex=1, startRow=1,endRow=1784)

data <- data[with(data, order(domain1_score)), ]

trainIndex <- createDataPartition(data$domain1_score, p = 0.8, list = FALSE)

training_essays <- data[trainIndex, ]
test_essays <- data[-trainIndex, ]

training_essays <- training_essays[with(training_essays, order(domain1_score)), ]
test_essays <- test_essays[with(test_essays, order(domain1_score)), ]
training_grades <- training_essays$domain1_score
test_grades <- test_essays$domain1_score
save(training_grades, file="training_grades.RData")
save(test_grades, file="test_grades.RData")

dir.create("essays", showWarnings = FALSE)
dir.create("test_essays", showWarnings = FALSE)

for(i in 1:nrow(training_essays)) {
    output <- paste("essays/", as.character(i), ".txt", sep="")
    fileConn <- file(output)
    writeLines(as.character(training_essays$essay[i]), fileConn)
    close(fileConn)
}

for(i in 1:nrow(test_essays)) {
    output <- paste("test_essays/", as.character(i), ".txt", sep="")
    fileConn <- file(output)
    writeLines(as.character(test_essays$essay[i]), fileConn)
    close(fileConn)
}

