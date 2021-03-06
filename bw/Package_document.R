#NOTE: You should already have
rm(list = ls())
try(remove.packages("bw"))

check     <- TRUE
vignettes <- TRUE

#Set to c++11 (because default is c98)
#Sys.setenv("CXX"="g++")

#Set directory
dir <- "~/Dropbox/INSP/HALL/bw package 2018 v2/" #Rod <- 
#dir <- "~/Dropbox/INSP/HALL/bw package 2018/" #Rod <- 
#dir <- "~/Dropbox/bw package 2018/" #Dalia

setwd(dir)

#Get path for package and try to delete it if already exists
path <- path.expand(paste0(dir,"/bw"))
try(unlink(path, TRUE,TRUE))

usethis::create_package(path.expand(paste0(dir,"/bw")), open = FALSE)
usethis::proj_set("bw")

description <- path.expand(paste0(dir,"DESCRIPTION"))
try(unlink(path, TRUE,TRUE))

usethis::use_description(fields = list(
  `Authors@R` = 'c(person("Dalia", "Camacho-García-Formentí", email = "daliaf172@gmail.com", role = c("aut","cre")), person("Rodrigo", "Zepeda-Tello", email = "rzepeda17@gmail.com", role = c("aut")))',
  Version     = "1.0.1",
  Date = "2018-07-01",
  Encoding    = "UTF-8",
  Description = 'Implementation of the dynamic weight change models for adults from "The Dynamics of Human Body Weight Change" by CC. Chow and KD. Hall (2008) <doi:10.1371/journal.pcbi.1000045>. As well as the children weight change model from "Dynamics of childhood growth and obesity: development and validation of a quantitative mathematical model" by KD. Hall, NF. Butte, BA. Swinburn, and CC. Chow (2013) <doi:10.1016/S2213-8587(13)70051-2>. These model the physiological processes related to weight change in each individual by considering each of the biological processes involved. This package was developed under funding by Bloomberg Philanthropies.',
  Title       = "Dynamic Body Weight Models for Children and Adults",
  Type        = "Package",
  VignetteBuilder = "knitr",
  LazyLoad    = "yes",
  LinkingTo   = "Rcpp",
  RoxygenNote = "6.0.1"
))

#Add suggests
for (package in c("testthat","knitr","rmarkdown")){
  usethis::use_package(package, "Suggests")
}

#Add imports
for (package in c("Rcpp", "compiler", "ggplot2", "gridExtra", "reshape2", "survey")){
  usethis::use_package(package, "Imports")
}

#Add license
usethis::use_mit_license(name = "Instituto Nacional de Salud Pública")

#Create namespace
usethis::use_namespace()

#Tests
usethis::use_testthat()

#Find manual and delete if exists
#manual_path <- path.expand(paste0(dir,"/bw.pdf"))
#try(unlink(manual_path, TRUE,TRUE))

#Get all files into package
Rfiles    <- list.files(paste0(dir,"/RFunctions/"), pattern = "\\.R",full.names = T)
Cfiles    <- list.files(paste0(dir,"/CppFunctions/"), pattern = "\\.cpp",full.names = T)
Hfiles    <- list.files(paste0(dir,"/CppFunctions/"), pattern = "\\.h",full.names = T)
Vfiles    <- list.files(paste0(dir,"/vignettes/"), pattern = "\\.Rmd",full.names = T)
HTMLfiles <- list.files(paste0(dir,"/vignettes/"), pattern = "\\.html",full.names = T)
Bibfiles  <- list.files(paste0(dir,"/vignettes/"), pattern = "\\.bib",full.names = T)
Cslfiles  <- list.files(paste0(dir,"/vignettes/"), pattern = "\\.csl",full.names = T)
Testfiles <- list.files(paste0(dir,"/tests/"), pattern = "\\.R",full.names = T)
Makevars  <- list.files(paste0(dir,"/Makevars/"), full.names = T)
#Makevars <- c()
#Get all code files into package
dir.create(file.path(paste0(dir,"/bw/"), "R"), showWarnings = FALSE)
for (f in Rfiles){
  file.copy(f, paste0(dir,"/bw/R/"), overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)
}

#Create src folder
usethis::use_rcpp()
for (f in c(Cfiles, Hfiles, Makevars)){
  file.copy(f, paste0(dir,"/bw/src/"), overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)
}

#Create tests
dir.create(file.path(paste0(dir,"/bw/"), "tests"), showWarnings = FALSE)
for (f in Testfiles){
  file.copy(f, paste0(dir,"/bw/tests/testthat/"), overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)
}

#Create vignettes
if(vignettes){
  dir.create(file.path(paste0(dir,"/bw/"), "vignettes"), showWarnings = FALSE)
  for (f in c(Vfiles, HTMLfiles, Bibfiles, Cslfiles)){
    file.copy(f, paste0(dir,"/bw/vignettes/"), overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)
  }
  
  #Set vignettes at inst-doc
  dir.create(file.path(paste0(dir,"/bw/"), "inst"), showWarnings = FALSE)
  dir.create(file.path(paste0(dir,"/bw/inst/"), "doc"), showWarnings = T)
  for (f in HTMLfiles){
     file.copy(f, paste0(dir,"/bw/inst/doc/"), overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)
  }
}

#Document using roxygen2. Seems to me redundant with use_namespace
devtools::document(pkg = "bw") #Restart R if not working
devtools::test(pkg = "bw")

#Check the package and be sad when it does not run
if (check){
  #Fedora 28 sends a compile code warning 
  #Found 'abort' possibly from 'abort'
  #Found 'printf' possibly from 'printf'
  #Which does not depend on our package but on Fedora's distribution
  #https://www.mail-archive.com/r-package-devel@r-project.org/msg02711.html
  #seems to be local, use https://github.com/r-hub/rhub
  devtools::check("bw",check_dir = getwd(), cleanup = TRUE, manual = TRUE)
}

#Remove so, and o files of c++
icons  <- list.files(paste0(dir,"/bw"), recursive = T, full.names = T, pattern = c("\\.o"))
cos    <- list.files(paste0(dir,"/bw"), recursive = T, full.names = T, pattern = c("\\.so"))

file.remove(icons)
file.remove(cos)

#Update installation of package
devtools::build("bw", manual = TRUE, vignettes = vignettes)

devtools::install("bw", build_vingettes = vignettes)

#Clear all
rm(list = ls())
beepr::beep(3)

#Restart R
.rs.restartR()

#Si ya pasó los checks de tu compu puedes usar rhub para checar
#library("rhub")
#validate_email("rzepeda17@gmail.com")
#check_on_fedora("bw") #etc porque hay check linux y demás

