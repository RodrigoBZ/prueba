## ---- echo = FALSE, message=FALSE, warning = FALSE-----------------------
require("bw")
require("ggplot2")

## ---- message = FALSE----------------------------------------------------
female_model1 <- child_weight(age = 7, sex = "female")

## ---- message = FALSE----------------------------------------------------
female_model2 <- child_weight(age = 7, sex = "female", FM = 19.9, FFM = 5.74)

## ---- eval = FALSE-------------------------------------------------------
#  female_model3 <- child_weight(age = 7, sex = "female", FM = 19.9, FFM = 5.74,
#                                EI = seq(1600, 1750, length.out = 365))

## ---- message = FALSE----------------------------------------------------
#Database information
ages    <- c(8, 10, 7, 7, 12)
sexes   <- c("male", "female", "female", "male", "male") 

#Returns a weight change matrix and other matrices
database_model <- child_weight(ages, sexes)

## ---- fig.width=6, fig.height=4------------------------------------------
model_plot(female_model2, "Body_Weight")

## ---- fig.width=6, fig.height=4------------------------------------------
model_plot(female_model2, c("Body_Weight", "Fat_Mass"))

## ---- fig.width=6, fig.height=4------------------------------------------
model_plot(female_model2, c("Body_Weight", "Fat_Mass"), timevar = "Age")

## ---- fig.width=6, fig.height=4------------------------------------------
girl <- child_weight(6,"female", days=365, dt = 5, 
                     richardsonparams = list(K = 2700, Q = 10, 
                                             B = 12, A = 3, nu = 4, 
                                             C = 1))
model_plot(girl, "Body_Weight")

## ---- message = FALSE----------------------------------------------------
#Database information
mydata <- data.frame(
  id = 1:5,
  age = c(8, 10, 7, 7, 12),
  sex = c("male", "female", "female", "male", "male"),
  energy = runif(5, 1500, 2000),
  prob = c(0.1, 0.2, 0.2, 0.05, 0.45))

#Get energy change with energy build function
eichange      <- energy_build(cbind(runif(5, 1500, 2000), mydata$energy), c(0, 365))

#Returns a weight change matrix and other matrices
database_model <- child_weight(mydata$age, mydata$sex, EI = t(eichange))

## ----fig.width=6, fig.height=4-------------------------------------------
model_plot(database_model, "Body_Weight")

## ---- eval = FALSE-------------------------------------------------------
#  model_mean(database_model, "Body_Weight")

## ---- echo = FALSE, warning = FALSE--------------------------------------
head(model_mean(database_model, "Body_Weight"))[,1:5]

## ---- eval = FALSE-------------------------------------------------------
#  model_mean(database_model, "Body_Weight", days = 1:365)

## ---- echo = FALSE, warning=FALSE----------------------------------------
head(model_mean(database_model, "Body_Weight", days = 1:365))[,1:5]

## ---- eval = FALSE-------------------------------------------------------
#  model_mean(database_model, "Body_Weight", days = 1:365, group = mydata$sex)

## ---- echo = FALSE, warning = FALSE--------------------------------------
head(model_mean(database_model, "Body_Weight", days = 1:365, group = mydata$sex))[,1:5]

## ---- eval = FALSE-------------------------------------------------------
#  require("survey")
#  design <- svydesign(ids = ~id, probs = ~prob, data = mydata)
#  model_mean(database_model, group = mydata$sex, design = design)

## ---- echo = FALSE, message=FALSE, warning = FALSE-----------------------
require("survey")
design <- svydesign(ids = ~id, probs = ~prob, data = mydata)
head(model_mean(database_model, group = mydata$sex, design = design))[,1:5]

## ---- eval = FALSE-------------------------------------------------------
#  browseVignettes("bw")

## ---- eval = FALSE-------------------------------------------------------
#  browseVignettes("bw")

