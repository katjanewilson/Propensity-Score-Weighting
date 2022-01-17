Town1 <- c(70, 65, 87, 67)
Town2 <- c(95, 88, 91, 101)
Town3 <- c(34,45,23,34)
Town4 <- c(46,24,35,55)
Town5 <- c(10,32,10,15)
NYC <- c(50,51,78,88)

df <- data.frame(Town1, Town2, Town3,
                 Town4, Town5, NYC)

set.seed(1)

# number of columns in the Lung and Blood data.frames. 22,000 for you?
n <- 5 

# dummy data
obs <- 50 # observations
Lung <- data.frame(matrix(rnorm(obs*n), ncol=n))
Blood <- data.frame(matrix(rnorm(obs*n), ncol=n))
Age <- sample(20:80, obs)
Gender  <- factor(rbinom(obs, 1, .5))

### question 1
## reshape
wide_to_long <- gather(df, name, value, Town1:NYC)
## aggregate
wide_to_long %>%
  group_by(name) %>%
  summarise(max= sd(value))
### question 2
if (min(df$Town2) %in% c(90,100)){
  print(median(df$NYC))
}
## question 3
# create empty list
coefficientst_list <- list()
predictors_list<- df[,1:5]
lms <- lapply(1:5, function(x) lm(NYC ~ predictors_list[,x]))
df_new <- sapply(lms, coef)
vector <- df_new[2,]
sum_abs_values <- sum(abs(vector))   
sum_abs_values
## question 4

df_res <- sapply(lms, residuals)

mod1 <- lm(NYC ~ Town1, data = df)
mod2 <- lm(NYC ~ Town1, data = df)
mod3 <- lm(NYC ~ Town1, data = df)
mod4 <- lm(NYC ~ Town1, data = df)
mod5 <- lm(NYC ~ Town1, data = df)
mse <- function(mod1){
  mean(mod1$residuals^2)
}
mse(mod1)
mse(mod2)
mse(mod3)
mse(mod4)
mse(mod5)

## question 5

# try all combinations of variables
model1 <- lm(NYC ~ Town1 + Town2, data = df)
model2 <- lm(NYC ~ Town1 + Town3, data = df)
model2 <- lm(NYC ~ Town1 + Town4, data = df)
# remove one to evaluate
mse(mod1)
mse(mod2)
mse(mod3)

