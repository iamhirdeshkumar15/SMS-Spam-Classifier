# Load the SMS spam dataset from a CSV file
sms_raw <- read.csv("sms_spam.csv")

# Check the structure of the dataset
str(sms_raw)

# Convert the 'type' column to a factor variable
sms_raw$type <- factor(sms_raw$type)

# Check the structure of the 'type' variable
str(sms_raw$type)

# Check the structure of the entire dataset again
str(sms_raw)

# Create a frequency table of the 'type' column
table(sms_raw$type)

# Install and load the 'tm' package for text mining
install.packages("tm")
library(tm)

# Create a text corpus from the 'text' column of the dataset
sms_corpus <- VCorpus(VectorSource(sms_raw$text))

# Print the corpus
print(sms_corpus)

# Inspect the first two documents in the corpus
inspect(sms_corpus[1:2])

# Convert the first document to character format
as.character(sms_corpus[[1]])

# Convert the first two documents to character format using lapply
lapply(sms_corpus[1:2], as.character)

# Convert all text in the corpus to lowercase
sms_corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))

# Check the first document in the original corpus
as.character(sms_corpus[[1]])

# Check the first document in the cleaned corpus
as.character(sms_corpus_clean[[1]])

# Remove numbers from the text
sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)

# Get the default English stopwords
a = stopwords()
a

# Remove stopwords from the corpus
sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())

# Remove punctuation from the text
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)

# Check the first document after cleaning
as.character(sms_corpus_clean[[1]])

# Install and load the 'SnowballC' package for stemming
install.packages("SnowballC")
library(SnowballC)

# Example of word stemming
wordStem(c("learn", "learned", "learning", "learns"))

# Apply stemming to the cleaned corpus
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

# Remove extra whitespace from the text
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

# Check the first document after all cleaning steps
as.character(sms_corpus_clean[[1]])

# Create a Document-Term Matrix (DTM) from the cleaned corpus
sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

# Inspect the Document-Term Matrix
inspect(sms_dtm)

# Split the DTM into training and testing sets
sms_dtm_train <- sms_dtm[1:4169, ]
inspect(sms_dtm_train)
sms_dtm_test <- sms_dtm[4170:5559, ]
inspect(sms_dtm_test)

# Extract the labels for training and testing sets
sms_train_labels <- sms_raw[1:4169, ]$type
sms_train_labels
sms_test_labels <- sms_raw[4170:5559, ]$type

# Install and load the 'wordcloud' package for visualization
install.packages("wordcloud")
library(wordcloud)

# Generate a word cloud from the cleaned corpus
wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE)

# Find frequent words that appear at least 5 times in the training set
sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
sms_freq_words # List of frequent words

# Create a Document-Term Matrix for frequent words in the training set
sms_dtm_freq_train <- sms_dtm_train[, sms_freq_words]
inspect(sms_dtm_freq_train)

# Create a Document-Term Matrix for frequent words in the testing set
sms_dtm_freq_test <- sms_dtm_test[, sms_freq_words]

# Convert counts to binary (Yes/No) for training set
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

# Apply the conversion function to the training set
sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
View(sms_train)

# Apply the conversion function to the testing set
sms_test <- apply(sms_dtm_freq_test, MARGIN = 2, convert_counts)

# Install and load the 'e1071' package for Naive Bayes
install.packages("e1071")
library(e1071)

# Train a Naive Bayes classifier on the training data
sms_classifier <- naiveBayes(sms_train, sms_train_labels)

# Make predictions on the testing data
sms_test_pred <- predict(sms_classifier, sms_test)

# Create a confusion matrix to compare predicted and actual labels
table(sms_test_pred, sms_test_labels)

# Load the 'gmodels' package for CrossTable function
library(gmodels)

# Display a cross table for detailed comparison of predictions
CrossTable(sms_test_pred, sms_test_labels)
