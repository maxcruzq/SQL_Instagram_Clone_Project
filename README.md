# SQL_Instagram_Clone_Project

## Overview
MySQL project that solves real business questions and scenarios, on a clone mimic version of Instagram database.

## Schema
* users (id, username, created_at)
* photos (id, image_url, user_id, created_dat)
* comments (id, comment_text, user_id, photo_id, created_at)
* likes (user_id, photo_id, created_at)
* follows (follower_id, followee_id, created_at)
* tags (id, tag_name, created_at)
* photo_tags (photo_id, tag_id)

## Real Business Questions
1. First 10 users on the platform
2. Total number of registrations
3. The day of the week most users register on
4. The users who have never posted a photo
5. The most likes on a single photo
6. The number of photos posted by most active users
7. The total number of posts
8. The total number of users with posts
9. The usernames with numbers as ending
10. The usernames with charachter as ending
11. The number of usernames that start with A
12. The most popular tag names by usage 
13. The most popular tag names by likes
14. The users who have liked every single photo on the site
15. Total number of users without comments
16. The percentage of users who have either never commented on a photo or likes every photo
17. Clean URLs of photos posted on the platform
18. Average time of existence of the accounts

## Tableau Dashboard
You can see the Dashboard in the following link:
https://public.tableau.com/app/profile/maximiliano.cruz/viz/InstagramCloneDataAnalysis/Dashboard1
