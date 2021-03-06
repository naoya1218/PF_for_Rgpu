#sampling DDR X_tは一次元ベクトル前提
r_DDR <- function(X_t, q_qnorm, rho, beta) {
  return ((q_qnorm - sqrt(rho)*sqrt(beta)*X_t) / sqrt(1 - rho) - sqrt(rho)*sqrt(1 - beta) / sqrt(1 - rho) * rnorm(length(X_t)))
}

#Dynamicdefaultrateでの観測変数に対する密度関数　実質正規分布　DRを正規分布の逆関数で変換する必要があることに注意
g_DR_dinamic <- function(tilde_DR, X_t_1, q_qnorm, beta, rho) {
  #return (dnorm(tilde_DR, (q_qnorm - sqrt(rho)*sqrt(beta)*X_t_1) / sqrt(1 - rho), sqrt(rho)*sqrt(1 - beta) / sqrt(1 - rho)))
  
  return(1 / ((sqrt(rho)*sqrt(1 - beta) / sqrt(1 - rho)) * sqrt(2 * pi)) *
           exp(-(tilde_DR - ((q_qnorm - sqrt(rho)*sqrt(beta)*X_t_1) / sqrt(1 - rho)))^2 /
                 (((sqrt(rho)*sqrt(1 - beta) / sqrt(1 - rho)))^2*2)))
  
}

#リサンプリング関数
resample <- function( cumsum_weight, x) {
  return(sapply(x, function(y) which(y < cumsum_weight)[1]))
}

#Dynamicdefaultrateでの潜在変数に対する密度関数

g_DR_dinamic_potencial <- function(X_t, X_t_1, beta) {
  
  
  return (1 / (sqrt(1 - beta) * sqrt(2 * pi))*exp( - (X_t -  sqrt(beta) * X_t_1)^2 / ((1 - beta) * 2)))
  
}

g_DR_dinamic_potencial_cross <- function(X_t, X_t_1, beta) {
  
  content <- log(exp( X_t ) %*%  (1/exp(sqrt(beta)*X_t_1)) )

  return (1 / (sqrt(1 - beta) * sqrt(2 * pi))*exp( - content^2 / ((1 - beta) * 2)))
}


