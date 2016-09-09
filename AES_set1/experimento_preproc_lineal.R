# Este codigo lo utilizo para aplicar regresion lineal al modelo baseline
# Y ver el comportamiento del mismo en 10 experimentos

library(caret)
library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R")
library(ggplot2)

load("grades")
dataset <- read.csv("dataset_features.csv")

# Preprocesamiento de los datos (normalizar y centrar)
normalization <- preProcess(dataset)
dataset.norm <- predict(normalization, dataset)

nzv <- nearZeroVar(dataset)
dataset <- dataset[, -nzv]

# Agrega las notas al dataset
dataset$grades <- grades

control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(dataset[,1:56], dataset[,57], sizes=c(1:56), rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))
