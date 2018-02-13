#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 10 15:08:33 2018

@author: abdoelhosary
"""

import tweepy, time
from tweepy import OAuthHandler



#enter the corresponding information from your Twitter application:
CONSUMER_KEY = 'Voy7bttxw8rKpC18wALNaKvup'#keep the quotes, replace this with your consumer key
CONSUMER_SECRET = 'wmg6HtRGs5Bnpohmp4ys6GoEAfsVRvc5N9mP2prm9w7MSsXj3G'#keep the quotes, replace this with your consumer secret key
ACCESS_KEY = '962464172695941120-STGTA2nI6DFz26yVAv61oDdGk5pr5ZM'#keep the quotes, replace this with your access token
ACCESS_SECRET = 'PaakHuSWYmFaA35jKmOdUDBecvYayOGzqV0vt3L9bFlSp'#keep the quotes, replace this with your access token secret
auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
api = tweepy.API(auth)
 
filename=open('TwitterBot.txt','r')
f=filename.readlines()
filename.close()
 
for line in f:
    api.update_status(status=line)
    time.sleep(900)#Tweet every 15 minutes
    
