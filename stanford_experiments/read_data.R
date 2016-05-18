library(xlsx)

data <- read.xlsx("training_set_rel3.xls", sheetIndex=1, startRow=1,endRow=1784)
grades <- data$domain1_score
save(grades, file="grades.RData")

for(i in 1:1783) {
    output <- paste("essays/", as.character(i), ".txt", sep="")
    fileConn <- file(output)
    writeLines(as.character(data$essay[i]), fileConn)
    close(fileConn)
}
