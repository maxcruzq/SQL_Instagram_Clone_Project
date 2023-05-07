/* INSTAGRAM CLONE EXPLORATORY DATA ANALYSIS USING SQL */

/* SQL SKILLS: joins, date manipulation, regular expressions, views, stored procedures, aggregate functions, string manipulation */
 
-- --------------------------------------------------------------------------------------------------------------

/*
----Schema----
users (id, username, created_at)
photos (id, image_url, user_id, created_dat)
comments (id, comment_text, user_id, photo_id, created_at)
likes (user_id, photo_id, created_at)
follows (follower_id, followee_id, created_at)
tags (id, tag_name, created_at)
photo_tags (photo_id, tag_id)
*/

-- --------------------------------------------------------------------------------------------------------------

/* 1. The first 10 users on the platform */

SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 10;

/* 2. Total number of registrations */
SELECT 
	COUNT(id) AS total_registrations
FROM
	users;
    
/* 3. The day of the week most users register on */
SELECT 
    DAYNAME(created_at) AS day_of_week,
    COUNT(id) AS total_registrations
FROM
    users
GROUP BY day_of_week
ORDER BY total_registrations DESC;

/* 4. The users who have never posted a photo */
SELECT 
    u.id, u.username, 
    COUNT(p.id) AS total_photos
FROM
    users AS u
        LEFT JOIN
    photos AS p ON u.id = p.user_id
GROUP BY u.id
HAVING total_photos = 0;

/* 5. The most likes on a single photo */
SELECT
	p.user_id,
	l.photo_id,
    p.image_url,
    COUNT(l.user_id) AS total_likes
FROM 
	photos AS p
		LEFT JOIN
	likes AS l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC
LIMIT 1;

/* 6. The number of photos posted by most active users */
SELECT
	u.id,
    u.username,
    COUNT(p.id) AS total_photos
FROM 
	users AS u
		LEFT JOIN
	photos AS p ON u.id = p.user_id
GROUP BY u.id
ORDER BY total_photos DESC
LIMIT 1;

/* 7. The total number of posts */
SELECT
	COUNT(id) AS total_posts
FROM
	photos;

/*8. The total number of users with posts */
SELECT
	COUNT(DISTINCT u.id) AS users_with_posts
FROM 
	users AS u
		INNER JOIN
	photos AS p ON u.id = p.user_id;
    
/* 9. The usernames with numbers as ending */
SELECT
	username
FROM 
	users
WHERE username REGEXP '[0-9]+$';

/* 10. The usernames with charachter as ending */
SELECT
	username
FROM 
	users
WHERE username REGEXP '[a-zA-Z]$';

/* 11. The number of usernames that start with A */
SELECT
	COUNT(username)
FROM 
	users
WHERE username LIKE 'A%';

/* 12. The most popular tag names by usage */
SELECT
	t.id,
    t.tag_name,
    COUNT(pt.photo_id) AS total_tags
    
FROM 
	tags AS t
		INNER JOIN
	photo_tags AS pt ON t.id = pt.tag_id
GROUP BY t.id
ORDER BY total_tags DESC
LIMIT 1;

/* 13. The most popular tag names by likes */
SELECT
	t.id,
    t.tag_name,
    COUNT(l.photo_id) AS total_likes
FROM 
	tags AS t
		INNER JOIN
	photo_tags AS pt ON t.id = pt.tag_id
		INNER JOIN
	likes AS l ON pt.photo_id = l.photo_id
GROUP BY t.id
ORDER BY total_likes DESC
LIMIT 1;

/* 14. The users who have liked every single photo on the site */
WITH rank_unique_photo_likes AS (
SELECT
	RANK() OVER (ORDER BY COUNT(l.photo_id) DESC) AS ranking,
	u.id,
    u.username,
    COUNT(l.photo_id) AS unique_total_photos_id
FROM 
	users AS u
		INNER JOIN
	likes AS l ON u.id = l.user_id
GROUP BY u.id
ORDER BY ranking
)

SELECT 
	*
FROM 
	rank_unique_photo_likes
WHERE ranking = 1;

/* Version 2 */
SELECT
	u.id,
    u.username,
    COUNT(l.user_id) AS unique_likes
FROM
	users AS u
		INNER JOIN
	likes AS l ON u.id = l.user_id
GROUP BY u.id
HAVING unique_likes = (
						SELECT
							COUNT(*)
						FROM
							photos
);

/* 15. Total number of users without comments */
SELECT
	COUNT(DISTINCT u.id) AS users_without_comments
FROM 
	users AS u
		LEFT JOIN
	comments AS c ON u.id = c.user_id
WHERE c.comment_text IS NULL;

/* 16. The percentage of users who have either never commented on a photo or likes every photo */
WITH like_every_photo AS (
							SELECT
								u.id,
								COUNT(l.photo_id) AS total_likes
							FROM 
								users AS u
									INNER JOIN
								likes AS l ON u.id = l.user_id
							GROUP BY u.id
							HAVING total_likes= (SELECT 
													COUNT(id)
												FROM 
													photos
                            )
),

never_commented AS (
					SELECT
						u.id
					FROM
						users AS u
							LEFT JOIN
						comments AS c ON u.id = c.user_id
					WHERE c.comment_text IS NULL
),

like_or_comment AS (
					SELECT 
						DISTINCT u.id
					FROM 
						users AS u
					WHERE u.id IN (
									SELECT
										id
									FROM
										like_every_photo
) OR u.id IN (
				SELECT
					id
				FROM
					never_commented
)
)

SELECT
	ROUND(((COUNT(lc.id) / COUNT(u.id)) * 100), 2) AS percentage
FROM 
	users AS u
		LEFT JOIN
	like_or_comment AS lc ON u.id = lc.id;
    
/* 17. Clean URLs of photos posted on the platform */
SELECT
	SUBSTRING_INDEX(image_url, '//', -1) AS clean_url
FROM
	photos;

/* 18. Average time of existence of the accounts */
SELECT 
    ROUND(AVG(DATEDIFF(CURDATE(), created_at)) / 360, 2) AS avg_years_in_platform
FROM
    users;
		
