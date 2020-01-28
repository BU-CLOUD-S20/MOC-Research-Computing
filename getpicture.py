#!/usr/bin/env python
# encoding: utf-8

import tweepy
import json
import twitter_credentials

def get_all_tweets():
#Twitter API credentials
    auth = tweepy.OAuthHandler(twitter_credentials.CONSUMER_KEY, twitter_credentials.CONSUMER_SECRET)
    auth.set_access_token(twitter_credentials.ACCESS_TOKEN, twitter_credentials.ACCESS_TOKEN_SECRET)
    api = tweepy.API(auth)
    keyword =input('input the keyword')

    #use a list to save all the tweets
    alltweets = {}
    new_tweets = api.user_timeline(api.search,q="",screen_name = keyword,count=20,include_rts =False,exclude_replies=True)
    if 'media' in new_tweets.entities:
        media = new_tweets.entities.get('media',[])
        alltweets[media[0]['media_url']] = new_tweets.favorite_count + new_tweets.retweet_count


    last_id = alltweets[-1].id-1
    #keep grabbing tweets until there are no tweets left to grab, ignoring retweets and replies
    while len(new_tweets) > 0:
        for tweet in api.user_timeline(screen_name = keyword,max_id = last_id):
            if 'media' in new_tweets.entities:
                media = new_tweets.entities.get('media',[])
                alltweets[media[0]['media_url']] = new_tweets.favorite_count + new_tweets.retweet_count

        #get the last_id so we can get earlier tweets
        last_id = alltweets[-1].id - 1
        print ("...{} tweets downloaded so far".format(len(alltweets)))
        #assume that either each tweet has only one media attachment or we only care about the first one
    tweets_ranking=sorted(alltweets ,key = lambda x : alltweets[x])


    #write tweet objects to JSON
    file = open('tweet.json', 'w')
    print ("Writing tweet objects to JSON please wait...")
    for status in tweets_ranking:
        json.dump(status,file,indent = 4)
    print ("Done")
    file.close()

if __name__ == '__main__':
    #pass in the username of the account you want to download
    get_all_tweets()
