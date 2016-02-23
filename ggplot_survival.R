#### Plot survival curves with ggplot

library(survival)
library(ggplot2)
library(ggfortify)

# first you need a survfit object
fit <- survfit(Surv(time, status) ~ 1, data = lung)

# standard r-base survival plot
plot(fit)

# convert survfit object to data frame
fit2  <- fortify(fit)

# get the same plot with ggplot
ggplot(data = fit2, aes(x = time, y = surv)) +
         # plot the confidence interval as area
         geom_ribbon(aes(ymax = upper, ymin = lower, alpha = .2)) +
         # plot survival curve
         geom_line() + 
         # plot censor marks
         geom_point(aes(shape = factor(ifelse(n.censor >= 1, 1, NA)))) + 
         # format censor shape as "+"
         scale_shape_manual(values = 3) + 
         # hide legends 
         guides(shape = "none", alpha = "none") 
