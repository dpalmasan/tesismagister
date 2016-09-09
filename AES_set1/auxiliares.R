# Funciones auxiliares para evaluar el modelo
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