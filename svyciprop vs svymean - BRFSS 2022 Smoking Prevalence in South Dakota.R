# install.packages("survey")
# install.packages("haven")
install.packages("surveytable")
library(survey)
library(haven)
library(surveytable)

path = "C:/Users/wrn0/GitHub/py2sas-brfss/data/LLCP2022.XPT"
df <- read_xpt(path)

# Restrict data to South Dakota
sd <- df[df$`_STATE` == 46, ]

# Re-code smoker variable to binary and null for non response
sd$CURRENTUSE <- NA
sd$CURRENTUSE[sd$`_RFSMOK3` == 1] <- 0
sd$CURRENTUSE[sd$`_RFSMOK3` == 2] <- 1
sd$CURRENTUSE[sd$`_RFSMOK3` == 9] <- NA

design <- svydesign(
  id = ~`_PSU`,
  strata = ~`_STSTR`,
  weights = ~`_LLCPWT`,
  data = sd)

# Prevalence and 95% CIs with svyciprops
prev_prop <- svyciprop(~CURRENTUSE, design, na.rm=TRUE)
print(prev_prop, digits = 6)  

# Prevalence and 95% CIs with svymeans
prev_mean <- svymean(~CURRENTUSE, design, na.rm = TRUE)
print(prev_mean, digits = 6)
print(confint(prev_mean), digits = 6)

design <- svydesign(
  id = ~`_PSU`,
  strata = ~`_STSTR`,
  weights = ~`_LLCPWT`,
  data = sd)

# Strashny (NCHS) method1 - params (method="beta", df=degf(design))
prev_nchs1 <- svyciprop(~CURRENTUSE, design, na.rm=TRUE, method="beta", df=degf(design))
print(prev_nchs1, digits = 6)  

# Strashny (NCHS) method2 - surveytable svyciprop_adjusted()
set_survey(design)
prev_nchs2 <- svyciprop_adjusted(~CURRENTUSE, design, df_method="default")
print(prev_nchs2, digits = 6)  
