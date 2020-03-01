#!/usr/bin/env python
# coding: utf-8

# Import the necessary libraries
# - To make a web page request
# - To save data to a dataframe
# - To interact with an SQL database
# - To parse web pages

# In[39]:


from bs4 import BeautifulSoup
import pandas as pd
import requests
from sqlalchemy import create_engine


# ### Web scrape a single web page and save the results to the simplyhired_job table

# Set a variable to store the web page URL

# In[2]:


url = 'https://www.simplyhired.com/search'


# Set a dict of parameters to pass to the URL

# In[43]:


params=dict(q='SQL')


# Make a GET request with the defined URL and the dict of parameters

# In[4]:


extended_request = requests.get(url, params=dict(q='SQL'))


# Confirm the GET request received a 200 HTTP status code

# In[5]:


extended_request


# View the text in the GET request result

# In[6]:


extended_request.text


# Create an object of the BeautifulSoup class to parse the web page text with the html.parser parser option

# In[7]:


soup = BeautifulSoup(extended_request.text, 'html.parser')


# Print the BeautifulSoup object as a nicely (pretty) formatted string

# In[8]:


print(soup.prettify())


# Open the URL in Chrome. Inspect the elements to find a pattern between the jobs.
# 
# Identify the tag, attribute, and attribute value for the outermost portion of each job.
# 
# Do a findAll to assign a list of jobs to a variable.

# In[12]:


jobs = soup.find('main', attrs={'id':'job-list'})


# Print out the variable containing the list of jobs

# In[13]:


print(jobs)


# - Create a dictionary to hold the job details. Initialize the dictionary values to an empty list for each key.
# 
# 
# - Loop through the jobs
#     - Scrape for the required job components and assign each to a variable
#     - Append the variable to the appropriate key for the dictionary initialized above
#     - Print out the variable value
#     - To delimit each article, print out a line of repeating non-alphanumeric characters of your choice

# In[63]:


job_details = {
    'job_title':[],
    'job_company':[],
    'job_location':[],
    'job_link':[]
}
for job in jobs:
    print(job)
    
    job_title = job.find('h2', attrs={'class':'jobposting-title'}).text
    job_details['job_title'].append(job_title)
    print('Job Title:', job_title)
    
    job_company = job.find('span', attrs={'class':'jobposting-company'}).text
    job_details['job_company'].append(job_company)
    print('Job Company:', job_company)
    
    job_location = job.find('span', attrs={'class':'jobposting-location'}).text
    job_details['job_location'].append(job_location)
    print('Job Location:', job_location)
    
    job_link = job.find('a', attrs={'rel':'nofollow','class':'card-link'}).text
    job_details['job_link'].append(job_link)
    print('Job Link:', job_link)
    
    print('*** *** *** *** *** ***')


# Print out the contents of the job details dictionary

# In[64]:


print(job_details)


# Assign the job details dictionary to a dataframe

# In[69]:


df=pd.DataFrame(job_details)
df.to_csv('job_details.csv', index = False)


# Print out the first 5 rows of the dataframe

# In[65]:


df.head(5)


# Establish a connection to your assignment_02 database.
# 
# Append ?charset=utf8 to the database name to avoide codec errors.

# In[66]:


engine = create_engine('mysql+mysqldb://lindseyf_dba:sql_2020@lindseyfry.lmu.build/lindseyf_assignment_02?charset=utf8')


# Insert the dataframe contents to the simplyhired_job table you previously created.
# 
# Ensure your variables in the jobs for loop matches the table's column names. 
# 
# Set the if_exists argument to append to insert into the table you already created.
# 
# Do not insert the dataframe's index column.

# In[67]:


df.to_sql('simplyhired_job', con = engine, if_exists='append', index = False)


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

# In[70]:


for pn in range(1,11):
    print('Page:', pn)
    
    url = 'https://www.simplyhired.com/search'
    params = {'q':'SQL', 'pn':pn}
    
    extended_request = requests.get(url, params=dict(q='SQL'))
    
    soup = BeautifulSoup(extended_request.text, 'html.parser')

    jobs = soup.find('main', attrs={'id':'job-list'})

    job_details = {
    'job_title':[],
    'job_company':[],
    'job_location':[],
    'job_link':[]
    }

    for job in jobs:
        print(job)

        job_title = job.find('h2', attrs={'class':'jobposting-title'}).text
        job_details['job_title'].append(job_title)
        print('Job Title:', job_title)

        job_company = job.find('span', attrs={'class':'jobposting-company'}).text
        job_details['job_company'].append(job_company)
        print('Job Company:', job_company)

        job_location = job.find('span', attrs={'class':'jobposting-location'}).text
        job_details['job_location'].append(job_location)
        print('Job Location:', job_location)

        job_link = job.find('a', attrs={'class':'card-link'}).text
        job_details['job_link'].append(job_link)
        print('Job Link:', job_link)

        print('*** *** *** *** *** ***')
        
    df=pd.DataFrame(job_details)
    df.to_csv('job_details.csv', index = False)
    
    df.to_sql('simplyhired_job', con = engine, if_exists='append', index = False)


# Confirm 100+ jobs were properly inserted into the simplyhired_job table. No need to provide proof. I will be running a SELECT on the table.
