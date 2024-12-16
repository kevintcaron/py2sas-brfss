install.packages("survey")
library(survey)

install.packages("haven")
library(haven)

df <- read_xpt("C:/Users/wrn0/GitHub/py2sas-brfss/data/LLCP2022.XPT")
sd <- df[df$`_STATE` == 46, ]
sd$CURRENTUSE <- NA
sd$CURRENTUSE[sd$`_RFSMOK3` == 1] <- 0  # No
sd$CURRENTUSE[sd$`_RFSMOK3` == 2] <- 1  # Yes
sd$CURRENTUSE[sd$`_RFSMOK3` == 9] <- NA  # Nonresponse

# Define the survey design object
design <- svydesign(
  id = ~`_PSU`,                 # PSU (Primary Sampling Unit)
  strata = ~`_STSTR`,           # Stratification variable
  weights = ~`_LLCPWT`,         # Weights
  data = sd                     # The dataframe with your survey data
)