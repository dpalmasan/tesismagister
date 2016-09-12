library(caret); library(Metrics); source("AgreementMeasures.R"); source("auxiliares.R"); library(ggplot2)

load("grades")
dataset <- read.csv("dataset_features.csv")

nzv <- nearZeroVar(dataset)
dataset <- dataset[, -nzv]

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

# Testear Seleccion de Features
library(MASS)

step <- stepAIC(mod, direction="both")
processed <- step$model

mod2 <- train(grades ~ ., data=processed, method="rf", trControl=trainControl(method="cv",number=5), 
              prox=TRUE, allowParallel=TRUE)
pred_base <- predict(mod2, test[, names(processed)])
ScoreQuadraticWeightedKappa(round2(pred_base), test$grades, 2, 12)
exactAgreement(round2(pred_base), test$grades)
adjacentAgreement(round2(pred_base), test$grades)
