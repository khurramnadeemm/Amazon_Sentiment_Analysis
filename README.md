# Sentiment Analysis on Amazon's 10-K Reports (2021-2025)
This repository contains the R script and supporting materials for a university project conducted for the "Programming for Finance" course. The project focuses on performing sentiment analysis on the Management's Discussion and Analysis (MD&A) sections of Amazon.com Inc.'s (AMZN) 10-K annual reports from 2021 to 2025. The core objective was to quantify the sentiment expressed in these financial narratives and assess its correlation with key financial performance indicators.
# Project Overview
In this project, we developed a robust analytical pipeline in R to extract, clean, and analyze textual data from Amazon's annual reports. By applying a lexicon-based sentiment analysis approach using the Loughran-McDonald Master Dictionary, we derived sentiment scores for each year's MD&A. These scores were then compared against crucial financial metrics such as Revenue, Net Income, Earnings Per Share (EPS), Return on Assets (ROA), and Stock Return to identify trends and correlations.
# Key Features
* PDF Text Extraction: Programmatic extraction of text from PDF-formatted 10-K MD&A sections using the pdftools library.

* Comprehensive Text Preprocessing: Cleaning of raw text data through lowercasing, removal of numbers, punctuation, and stopwords, and whitespace normalization using tm and stringr.

* Loughran-McDonald Sentiment Scoring: Application of a finance-specific sentiment lexicon to accurately quantify positive and negative sentiment within corporate disclosures.

* Financial Data Integration: Seamless integration of historical stock prices and financial fundamentals obtained from Yahoo Finance via the quantmod library.

* Comparative Analysis & Visualization: Generation of insightful plots using ggplot2 to visualize the relationship between textual sentiment and various financial performance metrics over time.
# Insights from Analysis

* The analysis revealed several compelling insights:

* Sentiment in Amazon's MD&A was mildly positive in 2021 and steadily increased from 2023 to 2025.

* A notable dip in sentiment occurred in 2022, directly correlating with Amazon's reported financial loss, tax risks, and broader post-pandemic uncertainties during that period.

* Despite consistent revenue growth, the sentiment dip in 2022 highlighted internal operational struggles.

* Stock returns largely mirrored sentiment trends, with a curious divergence in 2025 where high sentiment contrasted with a negative stock return, possibly influenced by external macroeconomic factors like the U.S.-China trade war.

* The year 2022 emerged as a critical inflection point where, despite record revenue, the company faced significant challenges that were reflected in a pronounced drop in sentiment.

* This project underscores the value of sentiment analysis as a powerful tool for interpreting qualitative factors in financial reporting, offering a deeper understanding beyond raw numerical data.
# Files in this Repository
* Group_9_Final_Project_Sentiment_Analysis_AMZN.R: The main R script containing the full code for text extraction, cleaning, sentiment analysis, financial data retrieval, and comparative plotting.

* G9_Final_Project_Report.pdf: The final project report detailing the methodology, results, and interpretation of the sentiment analysis.
# How to Run the R Script
To replicate the analysis:

1. Clone this repository:
git clone https://github.com/khurramnadeemm/Sentiment-Analysis-on-AMZN-10K-Reports.git

2. Install R Libraries: Ensure you have the necessary R packages installed. You can install them by running the following command in your R console:
install.packages(c("pdftools", "stringr", "tm", "ggplot2", "quantmod", "dplyr", "tidyr"))

3. Download Amazon 10-K MD&A Reports: Obtain the cropped MD&A sections of Amazon's 10-K reports for 2021-2025. These are typically sourced from Amazon's investor relations website or SEC EDGAR filings. Save them in a dedicated folder.

4. Download Loughran-McDonald Master Dictionary: Download the Loughran-McDonald_MasterDictionary_1993-2024.csv file.

5. Set Working Directory: Place the downloaded PDF MD&A files and the Loughran-McDonald dictionary CSV in a single folder. Set your R working directory to this folder using setwd(). For example:
setwd("path/to/your/project/folder")

6. Execute the Script: Run the Group_9_Final_Project_Sentiment_Analysis_AMZN.R script in your R environment.
# Group Members
* Mohammad Khurram (**Co Team Leader**)
  
* Saadan Ishaque (**Co Team Leader**)

* Muhammad Hammad 

* Shahzeb Imran 

* Suha Rupani 
# Contact
For any questions or collaborations, feel free to reach out to **Mohammad Khurram** at khurramnadeem164@gmail.com.
