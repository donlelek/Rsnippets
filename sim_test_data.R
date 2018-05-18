sim_test_data <-function (pop, prev, se, sp){
  test_data <<- data.frame(true = sample(c(1,0), 
                                         size = pop, 
                                         replace = TRUE, 
                                         prob = c(prev, 1-prev)
                                         )
                           ) %>% 
  mutate(test = ifelse(true == 0, 
                       rbinom(n = pop, size = 1, prob = 1-sp),
                       true * rbinom(n = pop, size = 1, prob = se)
                       ))

  print(table(test_data$true, test_data$test))
} 
  
sim_test_data(pop  = 10000,
              prev = .22,
              se   = .95,
              sp   = .5)


