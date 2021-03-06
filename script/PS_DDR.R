#weighttを更新するだけ
particle_smoother <- function(N, dT, beta_est, filter_X, filter_weight, filter_X_mean, smoother_weight, smother_X_mean){
  
  #初期値はそのまま
  smoother_weight[dT - 1  ,] <- filter_weight[dT - 1,] * 1
  smoother_X_mean[dT - 1,] <- filter_X_mean[dT - 1, ] * 1
  
  for (dt in seq(dT - 2, 1)){
    
    bunsi <- 0
    bunbo <- 0
    #ヘンテコなことしてます・・
    #tmp <- matrix(seq(1,11),ncol=10,nrow=10)
    #tmp2 <- matrix(seq(1,11),ncol=11,nrow=10)[,-1]
    #tmp[upper.tri(tmp)] <- tmp2[upper.tri(tmp2)]
    
    #suppressWarnings(T_1_f_matrix <- matrix(c(filter_X[dt + 1,],1), ncol=N, nrow=N))
    #T_1_f_tmp <- matrix(c(filter_X[dt + 1,],1), ncol=N+1, nrow=N)[,-1]
    #T_1_f_matrix[upper.tri(T_1_f_matrix)] <- T_1_f_tmp[upper.tri(T_1_f_tmp)]
    suppressWarnings(T_1_s_matrix <- matrix(c(smoother_weight[dt + 1,],1), ncol=N, nrow=N))
    T_1_s_tmp <- matrix(c(smoother_weight[dt + 1,],1), ncol=N+1, nrow=N)[,-1]
    T_1_s_matrix[upper.tri(T_1_s_matrix)] <- T_1_s_tmp[upper.tri(T_1_s_tmp)]
    #sm_weight_matrix <- g_DR_dinamic_potencial(vclMatrix(T_1_f_matrix),
    #                                           vclMatrix(matrix(filter_X[dt,],ncol=N,nrow=N)), beta_est)
    sm_weight_matrix <- g_DR_dinamic_potencial_cross(vclMatrix(matrix(filter_X[dt + 1,],nrow=N)),
                                               vclMatrix(matrix(filter_X[dt,],nrow=1)), beta_est)
    
    bunbo <- (vclVector(filter_weight[dt,]) %*% colSums(sm_weight_matrix))[] %>% sum()
    #bunsi <- rowSums(sm_weight_matrix) * vclVector(smoother_weight[dt + 1, ])
    #bunsi <- vclVector(smoother_weight[dt + 1, ]) * colSums(sm_weight_matrix)
    bunsi <- rowSums(vclMatrix(T_1_s_matrix) * (sm_weight_matrix))
    
    tmp_sm_weight <- (vclVector(filter_weight[dt,]) * (bunsi / bunbo))
    smoother_weight[dt,] <- (tmp_sm_weight / sum(tmp_sm_weight[]))[]
    smoother_X_mean[dt] <- (vclVector(smoother_weight[dt,]) %*% vclVector(filter_X[dt,]))[1]
   print(dt) 
  }
  
}
