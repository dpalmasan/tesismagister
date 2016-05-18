library(caret); library(kernlab); library(Metrics); source("AgreementMeasures.R");

# Leer calificacion de los ensayos
load("grades.RData")
dataset <- read.csv("essay_features.csv")
dataset$grades <- grades

round_tmp <- function(x, min.grade, max.grade) {
    tmp <- round(x)
    if(tmp < min.grade) {
        return(min.grade)
    }
    
    if(tmp > max.grade) {
        return(max.grade)
    }
    return(tmp)
}

round2 <- function(x, min.grade = 2, max.grade = 12) {
    return(mapply(round_tmp, x, MoreArgs = list(min.grade = min.grade, 
                                                max.grade = max.grade)))
}

# Crear particion de datos 90% training 10% testing
trainIndex <- createDataPartition(dataset$grades, p = .9, list = FALSE, times = 1)
training <- dataset[trainIndex, ]
testing <- dataset[-trainIndex, ]

##############################################################################
# Forward Feature Selection
formulas <- paste("grades ~", names(dataset), sep = " ")
formulas <- formulas[-c(length(formulas))]
kappas <- function(formula) {
    lmFit <- lm(as.formula(formula), data = training)
    pred <- predict(lmFit, testing)
    k <- ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
    return(k)
}

k <- sapply(formulas, kappas)
names(k) <- names(dataset[-c(14)])
k <- sort(k, decreasing = TRUE)
barplot(k, space = 1, las = 2)
lmFit <- lm(grades ~ ., data = training)
pred <- predict(lmFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
exactAgreement(round2(pred), testing$grades)
adjacentAgreement(round2(pred), testing$grades)
##############################################################################

lmFit <- train(grades ~ ., data = training, method = "lm",
               trControl = trainControl(method="cv"))
pred <- predict(lmFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
exactAgreement(round2(pred), testing$grades)
adjacentAgreement(round2(pred), testing$grades)
