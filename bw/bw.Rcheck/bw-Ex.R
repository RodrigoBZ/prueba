pkgname <- "bw"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "bw-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('bw')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("adult_bmi")
### * adult_bmi

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: adult_bmi
### Title: Get BMI prevalence results from Adult Weight Change Model
### Aliases: adult_bmi

### ** Examples

#EXAMPLE 1: RANDOM SAMPLE MODELLING
#--------------------------------------------------------

#Antropometric data
weights <- c(45, 67, 58, 67, 81)
heights <- c(1.30, 1.73, 1.77, 1.92, 1.73)
ages    <- c(45, 23, 66, 44, 23)
sexes   <- c("male", "female", "female", "male", "male") 

#Matrix of energy consumption reduction: 
EIchange <- rbind(rep(-100, 365), rep(-200, 365), rep(-200, 365), 
                  rep(-123, 365), rep(-50, 365))

#Create weight change model
model_weight <- adult_weight(weights, heights, ages, sexes, 
                             EIchange)
                             
#Calculate proportions
adult_bmi(model_weight)

#EXAMPLE 2: Survey data
#-------------------------------------------------------
set.seed(7423)

#Data frame for use in survey
probs   <- runif(10, 20, 60)
datasvy <- data.frame(
  id    = 1:10,
  bw    = runif(10,60,90),
  ht    = runif(10, 1.5, 2),
  age   = runif(10, 18, 80),
  sex   = sample(c("male","female"),10, replace = TRUE),
  kcal  = runif(10, 2000, 3000),
  group = sample(c(0,1), 10, replace = TRUE),
  svyw  = probs/sum(probs))

#Days to model
days <- 365

#Energy intake matrix
EIchange <- matrix(NA, ncol = days, nrow = 0)
for(i in 1:nrow(datasvy)){
    EIchange <- rbind(EIchange, rep(datasvy$kcal[i], days))
}

#Calculate weight change                   
weight <- adult_weight(datasvy$bw, datasvy$ht, datasvy$age, 
                          datasvy$sex, EIchange)


#Create survey design using survey package                           
design <- survey::svydesign(id = ~id, weights = datasvy$svyw, 
data = datasvy)
   
#' #Group to calculate means
group  <- datasvy$group     

#Calculate survey mean and variance for 25 days
adult_bmi(weight, design = design, group = group)
 



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("adult_bmi", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("adult_weight")
### * adult_weight

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: adult_weight
### Title: Dynamic Adult Weight Change Model
### Aliases: adult_weight

### ** Examples

#EXAMPLE 1: INDIVIDUAL MODELLING
#--------------------------------------------------------
#For one female in a diet of 100 kcal reduction. 
adult_weight(80, 1.8, 40, "female", rep(-100, 365))

#Same female also reducing sodium in -25mg
adult_weight(80, 1.8, 40, "female", rep(-100, 365), rep(-25, 365))

#Same female modelled for 400 days
adult_weight(80, 1.8, 40, "female", rep(-100, 400), rep(-25, 400), days = 400)

#Same female reducing -50 kcals per 100 days and not reducing sodium
kcalvec <-c(rep(-50, 100), rep(-100, 100), rep(-150, 100), rep(-200, 100))
adult_weight(80, 1.8, 40, "female", kcalvec, days = 400)

#Same female with known energy intake
adult_weight(80, 1.8, 40, "female", rep(-100, 365), rep(-25, 365), EI = 2000)

#Same female with known fat mass
adult_weight(80, 1.8, 40, "female", rep(-100, 365), rep(-25, 365), fat = 32)

#Same female with known fat mass and known energy consumption
adult_weight(80, 1.8, 40, "female", rep(-100, 365), rep(-25, 365), EI = 2000, fat = 32)

#EXAMPLE 2: DATASET MODELLING
#--------------------------------------------------------

#Antropometric data
weights <- c(45, 67, 58, 92, 81)
heights <- c(1.30, 1.73, 1.77, 1.92, 1.73)
ages    <- c(45, 23, 66, 44, 23)
sexes   <- c("male", "female", "female", "male", "male") 

#Matrix of energy consumption reduction: 
EIchange <- rbind(rep(-100, 365), rep(-200, 365), rep(-200, 365), 
                  rep(-123, 365), rep(-50, 365))

#Returns a weight change matrix and other matrices
model_weight <- adult_weight(weights, heights, ages, sexes, 
                             EIchange)["Body_Weight"][[1]]




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("adult_weight", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("child_reference_EI")
### * child_reference_EI

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: child_reference_EI
### Title: Energy Intake Matrix
### Aliases: child_reference_EI
### Keywords: internal

### ** Examples

#One child
child_reference_EI(6, "male", 2, 4, 10)

#Several children
child_reference_EI(sample(6:12, 10, replace = TRUE), 
                   sample(c("male","female"), 10, replace = TRUE), 
                   sample(2:10, 10, replace = TRUE), 
                   sample(2:10, 10, replace = TRUE),
                   365)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("child_reference_EI", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("child_reference_FFMandFM")
### * child_reference_FFMandFM

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: child_reference_FFMandFM
### Title: FFM and FM reference
### Aliases: child_reference_FFMandFM
### Keywords: internal

### ** Examples

#One child
child_reference_FFMandFM(6, "male")

#Several children
child_reference_FFMandFM(sample(6:12, 10, replace = TRUE), 
                   sample(c("male","female"), 10, replace = TRUE))




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("child_reference_FFMandFM", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("child_weight")
### * child_weight

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: child_weight
### Title: Dynamic Children Weight Change Model
### Aliases: child_weight

### ** Examples

#EXAMPLE 1: INDIVIDUAL MODELLING
#--------------------------------------------------------
#For one child with default energy intake
child_weight(6,"male")

#For a child with specific energy intake
child_weight(6,"male",2.5, 16, as.matrix(rep(2000, 365)), days = 365)

#Using Richardson's energy
girl <- child_weight(6,"female", days=365, dt = 5, 
                     richardsonparams = list(K = 2700, Q = 10, 
                     B = 12, A = 3, nu = 4, C = 1))
plot(girl$Body_Weight[1,])

#EXAMPLE 2: DATASET MODELLING
#--------------------------------------------------------
#Antropometric data
FatFree <- c(32, 17.2, 18.8, 20, 24.1)
Fat     <- c(4.30, 2.02, 3.07, 1.12, 2.93)
ages    <- c(10, 6.2, 5.4, 4, 4.1)
sexes   <- c("male", "female", "female", "male", "male") 

#With specific energy intake
eintake <- matrix(rep(2000, 365*5), ncol = 5)

#Returns a weight change matrix and other matrices
model_weight <- child_weight(ages, sexes, Fat, FatFree, eintake)

model_weight_2 <- child_weight(ages, sexes, Fat, FatFree, 
                    richardsonparams = list(K = 2700, Q = 10, 
                    B = 12, A = 3, nu = 4, C = 1))
         



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("child_weight", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("energy_build")
### * energy_build

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: energy_build
### Title: Energy Matrix Interpolating Function
### Aliases: energy_build

### ** Examples

#EXAMPLE 1: INDIVIDUAL MODELLING
#--------------------------------------------------------

#Get energy consumption
myconsumption <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Linear")
plot(1:(365*4), myconsumption, type = "l")

#Change interpolation to exponential
myexponential <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Exponential")
lines(1:(365*4), myexponential, type = "l", col = "red")

mystepwise    <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Stepwise_R")
lines(1:(365*4), mystepwise, type = "l", col = "blue")

mystepwise2    <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Stepwise_L")
lines(1:(365*4), mystepwise2, type = "l", col = "green")

mylogarithmic <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Logarithmic")
lines(1:(365*4), mylogarithmic, type = "l", col = "purple")

mybrownian    <- energy_build(c(0, 200, -500), c(0, 365*2, 365*4), "Brownian")
lines(1:(365*4), mybrownian, type = "l", col = "forestgreen")

#EXAMPLE 2: GROUP MODELLING
#--------------------------------------------------------

#Get energy consumption
multiple <- energy_build(cbind(runif(10,1000,2000), 
                                 runif(10,1000,2000), 
                                 runif(10,1000,2000)), c(0, 142, 365),
                                 "Brownian")
matplot(1:365, t(multiple), type = "l")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("energy_build", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("model_mean")
### * model_mean

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: model_mean
### Title: Get Mean results from Adult model Change Model
### Aliases: model_mean

### ** Examples

#EXAMPLE 1A: RANDOM SAMPLE MODELLING FOR ADULTS
#--------------------------------------------------------

#Antropometric data
models <- c(45, 67, 58, 92, 81)
heights <- c(1.30, 1.73, 1.77, 1.92, 1.73)
ages    <- c(45, 23, 66, 44, 23)
sexes   <- c("male", "female", "female", "male", "male") 

#Matrix of energy consumption reduction: 
EIchange <- rbind(rep(-100, 365), rep(-200, 365), rep(-200, 365), 
                  rep(-123, 365), rep(-50, 365))

#Create model change model
model_model <- adult_weight(models, heights, ages, sexes, 
                             EIchange)
                             
#Calculate survey mean and variance for 25 days

#EXAMPLE 1C: RANDOM SAMPLE MODELLING FOR CHILDREN
#--------------------------------------------------------
#Antropometric data
FatFree <- c(32, 17.2, 18.8, 20, 24.1)
Fat     <- c(4.30, 2.02, 3.07, 1.12, 2.93)
ages    <- c(10, 6.2, 5.4, 4, 4.1)
sexes   <- c("male", "female", "female", "male", "male") 

#Returns a model change matrix and other matrices
model_model <- child_weight(ages, sexes, Fat, FatFree)

#Calculate survey mean and variance for 25 days
  
#EXAMPLE 2A: SURVEY DATA FOR ADULTS
#-------------------------------------------------------

#EXAMPLE 2A: SURVEY DATA FOR CHILDREN
#-------------------------------------------------------



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("model_mean", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("model_plot")
### * model_plot

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: model_plot
### Title: Plot Results from Weight Change Model
### Aliases: model_plot

### ** Examples

#EXAMPLE 1A: INDIVIDUAL MODELLING FOR ADULTS
#--------------------------------------------------------
mymodel <- adult_weight(80, 1.8, 40, "female", rep(-100, 365))

#You can plot all the variables
model_plot(mymodel)

#Or only one of them
model_plot(mymodel, "Body_Weight", ncol = 1)

#EXAMPLE 1C: INDIVIDUAL MODELLING FOR CHILDREN
#--------------------------------------------------------
mymodel <- child_weight(5, "female", 12, 4)

#You can plot all the variables
model_plot(mymodel)

#Or only one of them and specify by age
model_plot(mymodel, "Body_Weight", ncol = 1)

#EXAMPLE 2A: DATASET MODELLING FOR ADULTS
#--------------------------------------------------------




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("model_plot", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
