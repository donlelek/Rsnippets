# this will be a great t-shirt one day
# source:
# http://stackoverflow.com/questions/39870405/plotting-equations-in-r

library(ggplot2)
library(dplyr)

L <- data_frame(x = 1:100,
                y = 1 / x)
O <- data_frame(t = seq(-pi, pi, l = 100),
                x = 3 * cos(t),
                y = 3 * sin(t))
V <- data_frame(x = -50:50,
                y = abs(-2 * x))
E <- data_frame(y = seq(-pi, pi, l = 100),
                x = -3 * abs(sin(y)))
pd <- bind_rows(L = L, O = O, V = V, E = E, .id = 'letter')

pd$letter <- factor(pd$letter, 
                    c('L', 'O', 'V', 'E'),
                    c('y == 1/x', 'x^2 + y^2 == 9', 'y == abs(-2*x)', 'x == -3*abs(sin(y))'))

ggplot(pd, aes(x, y)) +
  geom_vline(xintercept = 0, color = "white") + 
  geom_hline(yintercept = 0, color = "white") +
  geom_path(size = 1.5, col = 'red') +
  facet_wrap(~letter, scales = 'free', labeller = label_parsed, nrow = 1, switch = "x") +
  theme_minimal() +
  ggtitle("ALL YOU NEED IS") +
  theme(text = element_text(size = 30),
        plot.background = element_rect(fill = "black", color = "black"),
        axis.text = element_blank(), 
        axis.title = element_blank(),
        panel.grid = element_blank(),
        strip.text = element_text(color = "white", face = "italic"),
        title = element_text(color = "white", face = "bold"))

ggsave("~/Downloads/love_android.png", width = 19.20, height = 10.80, dpi = 100)
 
