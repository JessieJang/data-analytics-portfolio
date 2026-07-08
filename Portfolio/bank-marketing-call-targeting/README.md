# Project 1 — Mini

## Business Problem

What business question does this answer? Who is the stakeholder / decision-maker?

## Dataset

Source, size, time period, key fields.

## Tools

SQL / Excel / Python / Power BI

## Data Cleaning

- **duration** excluded — data leakage (only known after the call; 
  predictive but not actionable for targeting).
- **poutcome** unknowns (81.75%) kept — represent new clients with no 
  prior contact, not missing data. Dropping them would remove most of 
  the dataset.
- **contact** excluded from targeting — cellular (14.9%) and telephone 
  (13.4%) convert almost identically; unknown (4.1%) likely reflects 
  early data gaps, not the channel.

## Analysis

TBD

## Key Insights

TBD

## Business Recommendations

TBD

## Impact

Quantified impact statement — e.g. "identified the segment driving X% of attrition".
