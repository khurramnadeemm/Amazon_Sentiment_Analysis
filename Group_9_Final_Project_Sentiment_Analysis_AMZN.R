# R Script for Sentiment Analysis of Amazon's 10-K Reports (2021–2025)

# Note: Before running this script, please ensure the following:

# 1. You have installed all the necessary R libraries. If not, run:
#    install.packages(c("pdftools", "stringr", "tm", "ggplot2", "quantmod", "dplyr", "tidyr"))

# 2. You have downloaded the Amazon 10-K MD&A reports for the years 2021 to 2025 from LMS.
#    These reports contain only the MD&A sections cropped from the original 10-K filings.
#    that were downloaded from Amazons Website. This was done to ensure output integrity

# 3. Save all the MD&A PDF files (e.g., "Amazon_2025_10K.pdf", ..., "Amazon_2021_10K.pdf")
#    in a single folder and set your working directory to that folder using setwd():
#    Example: setwd("E:/Programming for Finance/Final Project")

# 4. Download the Loughran-McDonald Master Dictionary CSV file
#    (e.g., "Loughran-McDonald_MasterDictionary_1993-2024.csv") and save it in the same folder.
#    You can then read the dictionary using just the file name, as long as the working directory is set.

# After setting the working directory properly, you don't need to modify the file names
# or paths in the script.


# Load libraries
library(pdftools)   # For reading text from PDF files
library(stringr)    # For string manipulation
library(tm)         # For text mining tasks

# STEP 1: Extract text from PDF files
# Define the file paths to the Amazon 10-K reports for each year.
# IMPORTANT: Ensure these paths are correct for your system.
# File paths
file_paths <- c(
  "Amazon_2025_10K.pdf",
  "Amazon_2024_10K.pdf",
  "Amazon_2023_10K.pdf",
  "Amazon_2022_10K.pdf",
  "Amazon_2021_10K.pdf"
)

# Extract text content from each PDF file and store it in a list.
# Each element of the list will contain the combined text from all pages of a report.
amazon_texts <- lapply(file_paths, function(path) {
  text <- pdf_text(path)
  paste(text, collapse = " ")  # Combine all pages into one long string
})
# Assign names to each element of the list based on the year of the report.
names(amazon_texts) <- c("2025", "2024", "2023", "2022", "2021")


# STEP 2: Clean the text
# Define a function to clean the extracted text.
# This function converts text to lowercase, removes numbers and punctuation,
# removes common English stopwords, and strips extra whitespace.

clean_text <- function(text) {
  text <- tolower(text)
  text <- removeNumbers(text)
  text <- removePunctuation(text)
  text <- removeWords(text, stopwords("en"))
  text <- stripWhitespace(text)
  return(text)
}

# Apply the 'clean_text' function to each year's text in the 'amazon_texts' list.
# The cleaned text is stored in a new list called 'cleaned_amazon_texts'.

cleaned_amazon_texts <- lapply(amazon_texts, clean_text)

# STEP 3: Bag of Words Sentiment Analysis
# Load the Loughran-McDonald Master Dictionary from a CSV file.
# IMPORTANT: Ensure the path to the dictionary is correct for your system.

dictionary_path <- "Loughran-McDonald_MasterDictionary_1993-2024.csv"
lm_dict <- read.csv(dictionary_path)

# Convert the 'Word' column to lowercase for case-insensitive matching
lm_dict$Word <- tolower(lm_dict$Word)

# Filter the dictionary to extract lists of positive and negative words.

positive_words <- lm_dict$Word[lm_dict$Positive > 0]
negative_words <- lm_dict$Word[lm_dict$Negative > 0]

# Define a function to count positive and negative words in a given text
# and calculate a sentiment score.

get_sentiment_counts <- function(text, pos_words, neg_words) {
  # Split the text into individual words.
  words <- unlist(strsplit(text, "\\s+"))
  # Count the number of positive words present in the text.
  pos_count <- sum(words %in% pos_words)
  # Count the number of negative words present in the text.
  neg_count <- sum(words %in% neg_words)
  # Calculate the total number of words in the text.
  total_words <- length(words)
  # Calculate a normalized sentiment score.
  sentiment_score <- (pos_count - neg_count) / total_words
  # Return a named vector containing the positive count, negative count, and sentiment score.
  return(c(pos_count = pos_count, neg_count = neg_count, score = sentiment_score))
}

# Apply the 'get_sentiment_counts' function to each year's cleaned text.
# The results are stored in a list called 'sentiment_results'.

sentiment_results <- lapply(cleaned_amazon_texts, get_sentiment_counts, pos_words = positive_words, neg_words = negative_words)

# Convert the 'sentiment_results' list into a data frame.
sentiment_df <- as.data.frame(do.call(rbind, sentiment_results))
# Add a 'Year' column to the data frame based on the names of the 'sentiment_results' list.
sentiment_df$Year <- as.numeric(names(sentiment_results))

# Reorder the data frame by year.
sentiment_df <- sentiment_df[order(sentiment_df$Year), ]

# Load the ggplot2 library for creating visualizations.
library(ggplot2)

# Create a line plot showing the sentiment score over the years.

ggplot(sentiment_df, aes(x = Year, y = score)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "darkred", size = 3) +
  labs(title = "Amazon MD&A Sentiment Score (2021–2025)",
       x = "Year",
       y = "Sentiment Score") +
  theme_minimal()


# STEP 4: Get Stock Data and Financial Metrics

library(quantmod) # For downloading financial data

# Note: Stock returns for 2025 may change if this script is run before year-end, as Yahoo Finance fetches up-to-date data.

# Download daily stock prices for Amazon (AMZN) from Yahoo Finance for the period 2021-01-01 to 2025-12-31.
getSymbols("AMZN", src = "yahoo", from = "2021-01-01", to = "2025-12-31")

# Extract the daily closing prices from the downloaded AMZN stock data using Cl() function.
amzn_close <- Cl(AMZN)

# Define a function to calculate the annual return based on the first and last closing prices of a given year.
get_annual_return <- function(data, year) {
  yearly_data <- data[paste0(year)]
  start_price <- as.numeric(first(yearly_data))
  end_price <- as.numeric(last(yearly_data))
  return(round(((end_price - start_price) / start_price) * 100, 2))
}

# Apply the 'get_annual_return' function to calculate the annual stock return for each year.
years <- 2021:2025
stock_returns <- sapply(years, function(y) get_annual_return(amzn_close, y))

# Create a data frame containing Amazon's key financial metrics (Revenue, Net Income, EPS, ROA)
# for the years 2021 to 2025. The values are in billions of USD for Revenue and Net Income,
# in USD for EPS (assumed to be diluted EPS), and in percentage for ROA. The Stock Return is also included.
# Note: The financial data here is assumed to be obtained from reliable sources
# (e.g., Yahoo Finance, Macrotrends) and directly entered.
financial_data <- data.frame(
  Year = years,
  Revenue = c(469.82, 513.98, 574.79, 637.96, 650.31),      # in billions USD
  Net_Income = c(33.36, -2.72, 30.43, 59.25, 65.94),        # in billions USD
  EPS = c(64.81, -0.27, 2.96, 4.78, 6.37),                  # in USD
  ROA = c(7.93, -0.59, 5.76, 9.48, 10.96),                  # %
  Stock_Return = stock_returns                               # %
)

# Merge the sentiment score data frame ('sentiment_df') with the financial data frame ('financial_data')
# based on the 'Year' column.
combined_df <- merge(sentiment_df, financial_data, by = "Year")
# Print the resulting merged data frame.
print(combined_df)


library(ggplot2)
library(dplyr)   # For data manipulation
library(tidyr)   # For data reshaping

# Prevent dplyr from masking base R's lag() function to ensure compatibility with xts
conflictRules("dplyr", exclude = "lag")

# Step 5: Create comparison plots with clear legend
# Define a function to create a single comparison plot showing the sentiment score
# and one financial metric over time. The legend will clearly label each line.
create_single_comparison_plot <- function(data, metric_col, metric_label) {
  # Reshape the data frame to a longer format for easier plotting with ggplot2.
  plot_data <- data %>%
    select(Year, Sentiment = score, MetricValue = !!sym(metric_col)) %>%
    pivot_longer(cols = c(Sentiment, MetricValue),
                 names_to = "Metric",
                 values_to = "Value") %>%
    # Rename the 'Metric' categories for better readability in the plot legend.
    mutate(Metric = recode(Metric,
                           "Sentiment" = "Sentiment Score",
                           "MetricValue" = metric_label))
  
  # Create the ggplot2 line plot.
  ggplot(plot_data, aes(x = Year, y = Value, color = Metric)) +
    geom_line(size = 1.2) +
    geom_point(size = 3) +
    # Define the colors for the lines in the plot legend.
    scale_color_manual(
      name = "Metric",
      values = c("Sentiment Score" = "steelblue", metric_label = "darkgreen")
    ) +
    # Set the title and axis labels for the plot.
    labs(
      title = paste("Sentiment Score vs.", metric_label, "Over Time"),
      x = "Year",
      y = "Value"
    ) +
    # Use a minimal theme for the plot appearance.
    theme_minimal() +
    # Position the legend to the right of the plot.
    theme(legend.position = "right")
}

# Generate and print individual comparison plots for Sentiment Score vs. each financial metric.
revenue_plot <- create_single_comparison_plot(combined_df, "Revenue", "Revenue (Billion USD)")
print(revenue_plot)

net_income_plot <- create_single_comparison_plot(combined_df, "Net_Income", "Net Income (Billion USD)")
print(net_income_plot)

eps_plot <- create_single_comparison_plot(combined_df, "EPS", "EPS (USD)")
print(eps_plot)

roa_plot <- create_single_comparison_plot(combined_df, "ROA", "ROA (%)")
print(roa_plot)

stock_return_plot <- create_single_comparison_plot(combined_df, "Stock_Return", "Stock Return (%)")
print(stock_return_plot)