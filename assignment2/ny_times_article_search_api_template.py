#!/usr/bin/env python
# coding: utf-8

# Import the necessary libraries
# - To make an API request
# - To decode JSON
# - To save data to a dataframe
# - To interact with an SQL database

# In[76]:


import requests
import json
import pandas as pd
from sqlalchemy import create_engine


# ### Make a single API request and save the results to the nyt_article table

# Set a variable to store the API endpoint URL

# In[85]:


api_key = 'sgBFDFyjvlJyF1xsAcUDZUQV2neZzQ1r'
article_api_url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'


# Set a dict of parameters to pass to the API endpoint URL

# In[92]:


params = {'api-key':api_key, 'begin_date':'20190101', 'end_date':'20191231', 'q':'Los Angeles'}


# Make an API GET request with the defined API endpoint URL and the dict of parameters

# In[96]:


articles_request = requests.get(article_api_url, params=params)


# Confirm the API request received a 200 HTTP status code

# In[97]:


articles_request


# View the text in the API request result

# In[99]:


articles_request.text


# Decode the API result text as JSON

# In[100]:


decoded_articles_request_text = json.loads(articles_request.text)


# Assign the decoded API request JSON result to a variable

# In[126]:


articles = decoded_articles_request_text['response']['docs']


# Print out the dictionary value for the key containing the list of articles in the decoded API request JSON result

# In[127]:


type(articles)


# Assign the list of articles to a variable that will be later used to loop through

# In[137]:


for article in articles:
    print(article['_id'])


# Confirm the type of variable for the list of articles variable

# In[139]:


type(articles)


# - Create a dictionary to hold the article details. Initialize the dictionary values to an empty list for each key.  
# 
# 
# - Loop through the articles
#     - Assign the JSON values you will eventually store in a table to a variable
#     - Convert the pub_date to a [datetime format](https://www.geeksforgeeks.org/python-pandas-to_datetime/)
#     - Append the variable to the appropriate key for the dictionary initialized above
#     - Print out the variable value
#     - To delimit each article, print out a line of repeating non-alphanumeric characters of your choice

# In[136]:


nyt_article_data = {
    '_id':[], 
    'web_url':[],
    'headline':[],
    'document_type':[],
    'pub_date':[],
    'word_count':[],
    'type_of_material':[]
}

for article in articles:
    _id = article['_id']
    nyt_article_data['_id'].append(_id)
    print (_id)
    
    web_url = article['web_url']
    nyt_article_data['web_url'].append(web_url)
    print (web_url)
    
    headline = article['headline']
    nyt_article_data['headline'].append(headline)
    print (headline)
    
    document_type = article['document_type']
    nyt_article_data['document_type'].append(document_type)
    print (document_type)
    
    pub_date = article['pub_date']
    nyt_article_data['pub_date'].append(pub_date)
    print (pub_date)
    
    word_count = article['word_count']
    nyt_article_data['word_count'].append(word_count)
    print (word_count)
    
    type_of_material = article['type_of_material']
    nyt_article_data['type_of_material'].append(type_of_material)
    print (type_of_material)
    
    print('*****************************')


# Print out the contents of the article details dictionary

# In[ ]:





# Assign the article details dictionary to a dataframe

# In[ ]:





# Print out the first 5 rows of the dataframe

# In[ ]:





# Establish a connection to your assignment_02 database.
# 
# Append ?charset=utf8 to the database name to avoide codec errors.

# In[ ]:





# Insert the dataframe contents to the nyt_article table you previously created.
# 
# Ensure your variables in the articles for loop matches the table's column names. 
# 
# Set the if_exists argument to append to insert into the table you already created.
# 
# Do not insert the dataframe's index column.

# In[ ]:





# ---

# ### Clear out the nyt_article table before proceeding. 
# Run the following SQL in phpMyAdmin or TablePlus:
# 
# TRUNCATE TABLE nyt_article;
# 

# ---

# ### Make 10 requests to the API to collect 100 articles and save the results to the nyt_article table
# A single API requests only returns 10 articles. Use the page parameter to "paginate" through the results.
# 
# The range function returns a range of numbers. range(10) returns 0-9.
# 
# Replace the placeholders denoted by \~ALL_CAPS\~.

# In[ ]:


for ~PAGE_VARIABLE~ in range(10):
    print('Page:', ~PAGE_VARIABLE~)
        
    api_url = ~API_ENDPOINT_URL~
    params = {'api-key':~API_KEY~, 'page':~PAGE_VARIABLE~, 'begin_date':~BEGIN_DATE~, 'end_date':~END_DATE~, 'q':~KEYWORD~}

    ~MAKE_API_REQUEST~

    ~DECODE_JSON_API_REQUESTS_RESULTS_AND_ASSIGN_TO_A_VARIABLE~

    ~ASSIGN_ARTICLES_LIST_TO_A_VARIABLE~

    ~INITIALIZE_DICTIONARY_TO_STORE_ARTICLE_DETAILS~

    ~LOOP_THROUGH_ARTICLES~
        
        ~WEB_URL~
        
        ~MAIN_HEADLINE~
        
        ~DOCUMENT_TYPE~

        ~PUB_DATE~

        ~WORD_COUNT~

        ~TYPE_OF_MATERIAL~

        ~PRINT_NONALPHANUMERIC_ARTICLE_DELIMITER~
        
    ~ASSIGN_ARTICLES_DICTIONARY_TO_A_DATAFRAME~
    
    ~INSERT_DATAFRAME_INTO_nyt_article_TABLE_WITH_if_exists_append_OPTION~
    


# Confirm 100 articles were properly inserted into the nyt_article table. No need to provide proof. I will be running a SELECT on the table.
