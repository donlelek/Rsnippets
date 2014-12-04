# Let's say we're doing some analysis on the mtcars data..

# displacement/cylinder for high horsepower cars 
mtcars %>% 
  filter(hp > 100) %>% 
  mutate(disp_cyl = disp/cyl) %>% filter(disp_cyl > 25) %>%
  group_by(cyl,am) %>% summarise(mean_hp = mean(hp), mean_disp_cyl = mean(disp_cyl))

# or displacement/cylinder for all cars
mtcars %>%  
  mutate(disp_cyl = disp/cyl) %>% filter(disp_cyl > 25) %>%
  group_by(cyl,am) %>% summarise(mean_hp = mean(hp), mean_disp_cyl = mean(disp_cyl))

# That's beautiful! Thanks dplyr!

# Do magrittr functional sequences let me create resuable chunks of dplyr that I can chain together?
step1 <- . %>% filter(hp > 100)
step2 <- . %>% mutate(disp_cyl = disp/cyl) %>% filter(disp_cyl > 25)
step3 <- . %>% group_by(cyl,am) %>% summarise(mean_hp = mean(hp), mean_disp_cyl = mean(disp_cyl))

# displacement/cylinder for high horsepower cars?
mtcars %>% step1 %>% step2 %>% step3

# displacement/cylinder for all cars (i.e. leave out step 1)
mtcars %>% step2 %>% step3

# Turns out that yes, magrittr functionals can create reusable chunks dplyr commands!