library(caret); library(kernlab); library(Metrics); source("AgreementMeasures.R");

# Leer calificacion de los ensayos
load("grades.RData")
dataset <- read.csv("essay_features.csv")
dataset$grades <- grades

nsv <- nearZeroVar(dataset)
dataset <- dataset[, -nsv]

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
trainIndex <- createDataPartition(dataset$grades, p = .8, list = FALSE, times = 1)
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
names(k) <- names(dataset)[-c(57)]
k <- sort(k, decreasing = TRUE)
asd <- names(k)
names(k) <- NULL

# Open png device; create "plot1.png" in my wd.
png(filename="plot1.png", width = 640, height = 480)

end_point = 0.5 + length(k) + length(k)-1
barplot(k, space = 1, las = 2, ylab = "Quadratic Weighted Kappa", xlab = "",
        main = "QWK for single feature using LR")

text(seq(1.5,end_point,by=2), par("usr")[3], 
     srt = 60, adj= 1, xpd = TRUE,
     labels = paste(asd), cex=1)

# close the png file device
dev.off()

n <- length(k)
var <- names(k)
formulas <- 1:n

out <- vector()
out[1] <- paste("grades ~",var[1])
for (i in 2:length(var)) out[i] <- paste(out[i-1], "+",var[i])

best_performance <- 0
selected_model <- "grades ~ ."
for (formula in out) {
    lmFit <- lm(as.formula(formula), data = training)
    pred <- predict(lmFit, testing)
    kp <- ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
    if(kp > best_performance) {
        best_performance <- kp
        selected_model <- formula
    }
}

lmFit <- lm(grades ~ ., data = training)
pred <- predict(lmFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
exactAgreement(round2(pred), testing$grades)
adjacentAgreement(round2(pred), testing$grades)
##############################################################################

rfFit <- train(as.formula(selected_model), data = training, method = "rf", 
               ntree = 100,
               trControl = trainControl(method="cv"), number = 5)
pred <- predict(rfFit, testing)
ScoreQuadraticWeightedKappa(round2(pred), testing$grades, 2, 12)
exactAgreement(round2(pred), testing$grades)
adjacentAgreement(round2(pred), testing$grades)

