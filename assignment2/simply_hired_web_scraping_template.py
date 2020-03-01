#!/usr/bin/env python
# coding: utf-8

# Import the necessary libraries
# - To make a web page request
# - To save data to a dataframe
# - To interact with an SQL database
# - To parse web pages

# In[22]:


from bs4 import BeautifulSoup
import pandas as pd
import requests


# ### Web scrape a single web page and save the results to the simplyhired_job table

# Set a variable to store the web page URL

# In[71]:


url = 'https://www.simplyhired.com'


# Set a dict of parameters to pass to the URL

# In[72]:


params=dict(query='web scraping')


# Make a GET request with the defined URL and the dict of parameters

# In[124]:


extended_request = requests.get(url, params=dict(q='SQL'))


# Confirm the GET request received a 200 HTTP status code

# In[117]:


extended_request


# View the text in the GET request result

# In[118]:


extended_request.text


# Create an object of the BeautifulSoup class to parse the web page text with the html.parser parser option

# In[119]:


soup = BeautifulSoup(extended_request.text, 'html.parser')


# Print the BeautifulSoup object as a nicely (pretty) formatted string

# In[120]:


print(soup.prettify())


# Open the URL in Chrome. Inspect the elements to find a pattern between the jobs.
# 
# Identify the tag, attribute, and attribute value for the outermost portion of each job.
# 
# Do a findAll to assign a list of jobs to a variable.

# In[136]:


jobs = soup.find_all('div', attrs={'class':'HomepageSerp-content'})


# Print out the variable containing the list of jobs

# In[137]:


print(jobs)


# - Create a dictionary to hold the job details. Initialize the dictionary values to an empty list for each key.
# 
# 
# - Loop through the jobs
#     - Scrape for the required job components and assign each to a variable
#     - Append the variable to the appropriate key for the dictionary initialized above
#     - Print out the variable value
#     - To delimit each article, print out a line of repeating non-alphanumeric characters of your choice

# In[138]:


for job in jobs:
    print(job)
    
    job_title = job.find('div', attrs={'class':'jobposting-title-container'})
    print('Job Title:', job_title)
    
    job_link = job.findAll('a', attrs={'rel':'nofollow'})
    print('Job Link:', job_link)
    print('*** *** *** *** *** ***')


# Print out the contents of the job details dictionary

# In[ ]:





# Assign the job details dictionary to a dataframe

# In[ ]:





# Print out the first 5 rows of the dataframe

# In[ ]:





# Establish a connection to your assignment_02 database.
# 
# Append ?charset=utf8 to the database name to avoide codec errors.

# In[ ]:





# Insert the dataframe contents to the simplyhired_job table you previously created.
# 
# Ensure your variables in the jobs for loop matches the table's column names. 
# 
# Set the if_exists argument to append to insert into the table you already created.
# 
# Do not insert the dataframe's index column.

# In[ ]:





# ### Clear out the simplyhired_job table before proceeding. 
# Run the following SQL in phpMyAdmin or TablePlus:
# 
# TRUNCATE TABLE simplyhired_job;
# 

# ### Make 10 requests for the SimplyHired search page to scrape 100+ jobs and save the results to the simplyhired_job table
# A single job search request only returns ~10 jobs. Use the pn parameter to "paginate" through the results.
# 
# The range function returns a range of numbers. range(1,11) returns 1-10.
# 
# Replace the placeholders denoted by \~ALL_CAPS\~.

# In[ ]:


for ~PAGE_VARIABLE~ in range(1,11):
    print('Page:', ~PAGE_VARIABLE~)
    
    url = ~WEB_PAGE_URL~
    params = {'q':~KEYWORD~, 'pn':~PAGE_VARIABLE~}
    
    ~MAKE_WEB_PAGE_REQUEST~
    
    ~CREATE_BEAUTIFULSOUP_OBJECT_TO_PARSE_WEB_PAGE~

    ~FIND_ALL_JOBS_AND_ASSIGN_TO_A_VARIABLE~

    ~INITIALIZE_DICTIONARY_TO_STORE_JOB_DETAILS~

    ~LOOP_THROUGH_JOBS~
    
        ~TITLE~

        ~COMPANY~

        ~LOCATION~

        ~LINK~

        ~PRINT_NONALPHANUMERIC_JOB_DELIMITER~
        
    ~ASSIGN_JOBS_DICTIONARY_TO_A_DATAFRAME~
    
    ~INSERT_DATAFRAME_INTO_simplyhired_job_TABLE_WITH_if_exists_append_OPTION~


# Confirm 100+ jobs were properly inserted into the simplyhired_job table. No need to provide proof. I will be running a SELECT on the table.
