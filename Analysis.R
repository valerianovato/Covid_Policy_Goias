# analysis.R
# COVID-19 Policy Implementation in Goiás: Survey Analysis
# -----------------------------------------------
# NOTE:
# This script uses a simulated dataset to illustrate the analysis
# workflow. It has been adapted from the original study to preserve
# data confidentiality and research ethics.

# The logic, variables, and structure reflect the real analysis conducted
# for reporting to the Government of Goiás, but the data itself is not real.

# Load required libraries
library(tidyverse)
library(likert)
library(psych)

# -----------------------
# Step 1: Load and inspect the data
# -----------------------

# Suppose your CSV data is structured with:
# - demographic variables (e.g., type: "formal"/"informal")
# - likert items grouped by dimension

survey_data <- read_csv("goias_survey_data.csv")

# Check the structure
glimpse(survey_data)

# -----------------------
# Step 2: Define groups and dimensions
# -----------------------

# Business type as grouping variable
survey_data$type <- factor(survey_data$type, levels = c("formal", "informal"))

# Communication-related items
comm_items <- survey_data %>%
  select(comm1, comm2, comm3, comm4, comm5, comm6)

# Compliance-related items
comp_items <- survey_data %>%
  select(comp1, comp2, comp3, comp4, comp5, comp6)

# Legitimacy item (single question)
legitimacy <- survey_data %>%
  select(legit1)

# -----------------------
# Step 3: Likert visualization
# -----------------------

# Combine communication items into likert object
comm_likert <- likert(comm_items)
plot(comm_likert, group.order = "original") +
  ggtitle("Figure 1 - Communication Dimension Responses")

# Combine compliance items into likert object
comp_likert <- likert(comp_items)
plot(comp_likert, group.order = "original") +
  ggtitle("Figure 2 - Compliance Dimension Responses")

# Legitimacy (single item shown as frequency)
ggplot(survey_data, aes(x = legit1, fill = type)) +
  geom_bar(position = "dodge") +
  labs(title = "Figure 3 - Perceived Legitimacy", x = "Agreement Level", y = "Count")

# -----------------------
# Step 4: Chi-square tests (comparing groups)
# -----------------------

# Example: compliance item 3 (resistance from customers)
table_cust_resist <- table(survey_data$type, survey_data$comp3)
chisq.test(table_cust_resist)

# Example: compliance item 5 (employee confusion)
table_emp_confusion <- table(survey_data$type, survey_data$comp5)
chisq.test(table_emp_confusion)

# For each Likert item, you could repeat similar chi-square tests
# to assess where perceptions diverged between groups

# -----------------------
# Step 5: Optional summary tables
# -----------------------

# Descriptive statistics for communication items
describe(comm_items)

# Descriptive stats by group
survey_data %>%
  group_by(type) %>%
  summarise(across(comm1:comm6, mean, na.rm = TRUE))
