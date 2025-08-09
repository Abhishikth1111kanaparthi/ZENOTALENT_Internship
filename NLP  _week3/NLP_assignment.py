#!pip install nltk
#nltk.download('all')

import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer

import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
import re
import matplotlib.pyplot as plt

## task 1
stop_words = set(stopwords.words('english'))
def preprocess_text(text):
    text = text.lower()
    text = re.sub(r'[^a-zA-Z\s]', '', text)  # cleaning the strings
    tokens = word_tokenize(text) ## tokenization
    filtered_tokens = [word for word in tokens if word not in stop_words]  #filtering
    return filtered_tokens

data['processed_review'] = data['review'].apply(preprocess_text)  ## adding the tokenized data to the csv file
#display(data.head())
#data['processed_review']


## task 2 
def get_ngrams(corpus, n=1): ## func tp convet to n grams 
    vec = CountVectorizer(ngram_range=(n, n)).fit(corpus)
    bag_of_words = vec.transform(corpus)
    sum_words = bag_of_words.sum(axis=0)
    words_freq = [(word, sum_words[0, idx]) for word, idx in vec.vocabulary_.items()]
    words_freq = sorted(words_freq, key=lambda x: x[1], reverse=True)
    return words_freq

# Convert the list of tokens back to strings for CountVectorizer
data['processed_review_str'] = data['processed_review'].apply(lambda x: ' '.join(x))

# top 10 unigrams
top_unigrams = get_ngrams(data['processed_review_str'], n=1)[:10] ## unigrams
print("Top 10 Unigrams:")
for word, freq in top_unigrams:
    print(f"{word}: {freq}")

# top 10 bigrams
top_bigrams = get_ngrams(data['processed_review_str'], n=2)[:10] ## bigrams
print("\nTop 10 Bigrams:")
for word, freq in top_bigrams:
    print(f"{word}: {freq}")

# top 10 trigrams
top_trigrams = get_ngrams(data['processed_review_str'], n=3)[:10] ## trigrams
print("\nTop 10 Trigrams:")
for word, freq in top_trigrams:
    print(f"{word}: {freq}")

## task 3 
# Re-create the processed_review_str
data['processed_review_str'] = data['processed_review'].apply(lambda x: ' '.join(x))
# top 20 unigrams
top_unigrams = get_ngrams(data['processed_review_str'], n=1)[:20]
words, freqs = zip(*top_unigrams)

# bar plot
plt.figure(figsize=(9, 5))
sns.barplot(x=list(words), y=list(freqs), palette='viridis')
plt.xticks(rotation=45, ha='right')
plt.title('Top 20 Most Frequent Words')
plt.xlabel('Words')
plt.ylabel('Frequency')
plt.tight_layout()
plt.show()


## task 4
vectorizer = CountVectorizer()
X = vectorizer.fit_transform(data['processed_review_str'])

# Displaying the shape of the resulting sparse matrix
print("Shape of the Bag-of-Words matrix:", X.shape)
# Printing a few feature names
print("\nSample Feature Names:", vectorizer.get_feature_names_out()[:20])
