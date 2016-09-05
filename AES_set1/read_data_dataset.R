library(xlsx); library(caret)

data <- read.xlsx("training_set_rel3.xls", sheetIndex=1, startRow=1,endRow=1784)

data <- data[with(data, order(domain1_score)), ]
grades <- data$domain1_score
save(grades, file="grades")

dir.create("all_essays", showWarnings = FALSE)

for(i in 1:nrow(data)) {
    output <- paste("all_essays/", as.character(i), ".txt", sep="")
    fileConn <- file(output)
    writeLines(as.character(data$essay[i]), fileConn)
    close(fileConn)
}

