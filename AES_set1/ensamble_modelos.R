library(caret); library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R"); library(ggplot2)

load("grades")

# Conjunto de features simples
F1 <- read.csv("dataset_features.csv")
nzv <- nearZeroVar(F1)
F1 <- F1[, -nzv]

# Attali features
F2 <- read.csv("attali_features.csv")

dataset <- cbind(F1, F2)
dataset$grades <- grades

# Crea particion de datos
trainIndex <- createDataPartition(dataset$grades, p = 0.8, list = FALSE)
training <- dataset[trainIndex, ]
test <- dataset[-trainIndex, ]

mod <- lm(grades ~ ., data=training)
pred_base <- predict(mod, test)
ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
exactAgreement(round2(pred_base), test$grades)
adjacentAgreement(round2(pred_base), test$grades)
