# Request for Help with Variance Estimation Discrepancies Across Programming Languages

**Hello SAG colleagues,**

I hope you're all doing well and enjoying the holiday season. I've been grappling with some questions related to weighted variance estimation for a while, and I thought I'd reach out to the group for some help.

## TL;DR
While working with several programming languages for complex survey analysis, I've noticed that different languages, functions, and parameters yield slightly different 95% confidence intervals (CIs). I’m looking for a resource to help me understand:

1. Why these differences occur (at a mathematical level).
2. Key considerations when selecting a given method (function/parameter) in different circumstances.

## Context and Example:
I am a program evaluator with the Office on Smoking and Health, and I frequently work with epidemiologists, evaluators, and program directors at the state level who are interested in tobacco-related outcomes in their communities. The BRFSS is commonly used to monitor outcomes such as the prevalence of “Adults who are current smokers.” The BRFSS Calculated Variable, _RFSMOK3, is often used for this purpose in reports and dashboards, including those on the BRFSS site. However, the variance estimates can differ depending on the method used.

To illustrate this, I compared the proportion and mean functions across three programming languages (SAS, R, and Python) to estimate the prevalence and 95% CIs for “Adults who currently smoke” in South Dakota (2022). Here are the results:

| Language/Function | Estimate | Lower 95% CI | Upper 95% CI |
|-------------------|----------|--------------|--------------|
| **Proportion functions** |          |              |              |
| SAS (surveyfreq)  | 0.140159 | 0.116245     | 0.164074     |
| R (svyciprop)     | 0.140159 | 0.117906     | 0.165823     |
| samplics (PopParam.prop) | 0.140159 | 0.117907 | 0.165822 |
| **Means functions** |          |              |              |
| SAS (proc surveymeans) | 0.140159 | 0.116245     | 0.164074     |
| R (svymeans)      | 0.140159 | 0.116248     | 0.164071     |
| samplics (PopParam.mean) | 0.140159 | 0.116245 | 0.164074 |

Anyone should be able to reproduce these results by running the programs I’ve attached. You’ll need R/RStudio, SAS, and a Python installation with the samplics package and a few others (JupyterLab, NumPy, Pandas) for the Python Jupyter notebook. You’ll also need to download the 2022 BRFSS SAS file and adjust the path variables in the code. I’ve kept the code simple, using mostly default parameters, but I tried several options (see notes below). Please let me know if you spot anything incorrect in my code or results.

### Notes:
All the methods in question appear to use Taylor series linearization for variance estimates. Interestingly, only SAS generates the same CIs using both the proportion and mean methods for a binary variable. The BRFSS website and most CDC resources report the matching SAS CI numbers (LCI: 0.116, UCI: 0.164). I was surprised that R’s `svyciprop` function and Python’s samplics `PopParam.prop` did not produce the same CI estimates as SAS. I thought proportion estimates were appropriate for calculating binary prevalences, while means were better suited for continuous data (e.g., NHANES biomonitoring data for geomeans). I was even more surprised R’s `svymeans` function and the samplics `PopParam.mean` not only gave me a different result for my variance estimates but matched those produced by SAS. I tried adjusting various parameters (e.g., handling lonely PSUs, setting `alpha=0.5`, using extended significant figures) but couldn’t align the results.

### Questions:
While I understand that each language has a method for replicating the estimates of the others (except SAS → R/Python for proportions), I’d still like to understand why the CI estimates differ. I assumed that creating a binary variable and using means would yield the same results as using proportions. Why does this not hold true for R and Python? Is SAS doing this correctly since it produces the same result either way? Are there parameters I haven’t specified correctly in R and Python that would allow them to match SAS using proportions? Additionally, I’ve seen some estimates produced with SAS-Callable SUDAAN (particularly for percentile estimate variances) that I cannot replicate in R, Python, or stand-alone SAS. And finally, what factors should be considered when selecting a method for variance estimation?

Apologies for the lengthy message, and I appreciate any help you can provide!

**Cheers,**  
Kevin Caron
