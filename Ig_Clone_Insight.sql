
-- 2. We want to reward the user who has been around the longest, Find the 5 oldest users
SELECT * FROM users
order by created_at asc
limit 5

-- 3. To understand when to run the ad campaign, figure out the day of the week most users register on? 
SELECT dayname(created_at) Week_day,count(id) Totalusers FROM users
group by week_day
order by totalusers desc
limit 2

-- 4. To target inactive users in an email ad campaign, find the users who have never posted a photo.
with cte as (SELECT u.id,u.username,p.user_id from users u
left join photos p
on u.id=p.user_id
group by id)

select id,username from cte
where user_id is null

-- 5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
select p.user_id,a.photo_id,a.total_likes,u.username from photos p
inner join (SELECT photo_id,count(user_id) total_likes FROM ig_clone.likes
group by photo_id
order by total_likes desc
limit 1) a
on p.id=a.photo_id
inner join users u
on p.user_id=u.id

-- 6.The investors want to know how many times does the average user post.
select sum(total)/count(id) as avg_post from 

(with cte as (select user_id,count(id) as total from photos
group by user_id)
select users.id,total from cte
 right join users
 on cte.user_id=users.id) dd

-- 7. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
with cte as (SELECT t.id,t.tag_name,p.photo_id FROM tags t
cross join photo_tags p
on t.id=p.tag_id)

select tag_name,count(id) total from cte
group by tag_name
order by total desc
limit 5

-- 8. To find out if there are bots, find users who have liked every single photo on the site.
with cte as (SELECT user_id,count(photo_id) Total_photos FROM ig_clone.likes
group by user_id)
select user_id,total_photos from cte
where total_photos like (SELECT count(id) FROM ig_clone.photos)

-- 9.To know who the celebrities are, find users who have never commented on a photo.
select u.id,u.username,bb.user_id from users u
left join (SELECT count(photo_id) total,user_id FROM comments 
group by user_id) bb
on u.id=bb.user_id
where user_id is null

-- 10.Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.
with cte2 as (select u.id,u.username,dd.user_id from users u
inner join (with cte as (SELECT user_id,count(photo_id) total_photos  FROM comments
group by user_id)
Select user_id from cte
where total_photos like (SELECT count(id) FROM ig_clone.photos)) dd
on u.id=dd.user_id)

select id,username,
case 
when user_id is not null then 'Commented'
else 'Not Commented'
end user_id
from cte2

union 

(with cte as (select u.id,u.username,bb.user_id  from users u
left join (SELECT count(photo_id) total,user_id FROM comments 
group by user_id) bb
on u.id=bb.user_id
where user_id is null)
select id,username,
case 
when user_id is null then 'Not Commented'
else 'Commented'
end user_id
from cte)







