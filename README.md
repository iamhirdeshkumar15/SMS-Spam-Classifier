# SMS Spam Classification

This project implements an SMS spam classification model using the Naive Bayes algorithm in R. The model predicts whether an SMS message is spam or not based on its content.

## Dataset

The dataset used for this project is `sms_spam.csv`, which contains SMS messages labeled as either "spam" or "ham". 

### Dataset Structure
- **type:** Indicates whether the message is 'spam' or 'ham'
- **text:** The content of the SMS message

## Libraries Used

This project requires the following R packages:
- `tm` for text mining
- `SnowballC` for stemming
- `e1071` for Naive Bayes classification
- `gmodels` for cross-tabulation and analysis
- `wordcloud` for visualizing frequent words

You can install these packages using:

```R
install.packages(c("tm", "SnowballC", "e1071", "gmodels", "wordcloud"))
