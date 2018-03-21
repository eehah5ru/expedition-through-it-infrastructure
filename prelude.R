# 
# utils
# 
requireOrInstall <- function (packageName) {
  if (!require(packageName, character.only = TRUE)) {
    install.packages(packageName)
    library(packageName, character.only = TRUE)
  } else {
    library(packageName, character.only = TRUE)
  }
}

requireOrInstallFromSource <- function (packageName) {
  if (!require(packageName, character.only = TRUE)) {
    install.packages(packageName, type = "source", repo = "https://cran.rstudio.com/")
    library(packageName, character.only = TRUE)
  } else {
    library(packageName, character.only = TRUE)
  }  
}

requireOrInstallFromGithub <- function (packageName, githubName) {
  if (!require(packageName, character.only = TRUE)) {
    library(devtools)
    install_github(githubName)
    library(packageName, character.only = TRUE)
  } else {
    library(packageName, character.only = TRUE)
  }   
}
# 
# install deps
# 
packages <- c("jsonlite", "plyr", "psych", "stringi", "devtools")
packages <- lapply(packages, FUN = requireOrInstall)

#
# install updated ggmap library
# 
# remove.packages("ggrepel")
requireOrInstallFromSource("ggrepel")
requireOrInstallFromGithub("ggmap", "dkahle/ggmap")

# 
#  set options
# 
options(stringsAsFactors=TRUE)

# 
# set working directory
# 
setwd("/Volumes/bb3/_works/2016-expedition-through-dc/research")