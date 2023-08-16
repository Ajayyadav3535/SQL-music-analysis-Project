use music_store;
## Q1 : Who is the senior most Employee based On the Job title?

select last_name,First_name from employee 
order by level  desc
limit 1

### Q2 WHich Countries have the most invoices?

select count(*) as total, billing_country from invoice 
group by billing_country
order by total desc;

### Q3 what are top 3 values of total invoices?

select * from invoice 
order by total desc
limit 3;

#### Q4 Which city has the best customers?
 ## we would like to throw a promotional music festival in the city we made the most money
 ## write a query that returns one city that has the highest sum of invoices totals return both the city name and sums of all invoice totals?##
 
 select sum(total) as total_invoice,billing_city from invoice 
group by billing_city 
order by total_invoice desc
limit 1;

 ## Q5 WHo is the best customer?The customer who has spend the most money will be declaed the best customer .
write a query that returns the person who has spend the most money?

select concat(c.first_name," ",c.last_name),sum(i.total),from customer c
inner join invoice i on c.customer_id=i.customer_id
group by concat(c.first_name," ",c.last_name)
order by sum(i.total) desc
limit 1;


----------SET 2 ANSWERS-----------

## Q1 Wrie a query to return the email,firstname,lastname,and genre
of all rock music listners. return your list order alphabetically by email 
starting with A?

select distinct(email),first_name,last_name,genre.name from customer c inner join
invoice i on c.customer_id = i.customer_id inner join 
invoice_line il on i.invoice_id = il.invoice_id inner join
track on il.track_id = track.track_id inner join genre on
track.genre_id = genre.genre_id
where genre.name = "rock"
order by email asc;

##Q2-- Lets invite the artist who have written the most rock msic in our datasset.
 .write a query that returns the artist name and total track count of the top 10 rock bands?
 
 
select artist.artist_id, artist.name,count(artist.artist_id) as no_of_songs from track join
album2 on album2.album_id=track.album_id join artist on
album2.artist_id = artist.artist_id join genre on genre.genre_id
=track.genre_id
where genre.name like "Rock"
group by artist.artist_id 
order by no_of_songs desc
limit 10;
 
 Q3 return all the track names that have a song length 
 longer than the average song length.return the name and milliseconds for each track order by the song length with the longest songs 
 listed first?
 
 select name,milliseconds from track 
where milliseconds > (select avg(milliseconds) as avg_track_length from track)
order by milliseconds desc;
 
 SET 3 ANSWERS
 
 Q1 find how much amount spend by each customer on atists?
wrtie a query to return customer name,artist name and total spent?

select artist.artist_id, artist.name as artist_name,sum(invoice_line.unit_price*invoice_Line.quantity) as total_amount from artist
join album2 on artist.artist_id = album2.artist_id join track on album2.album_id = track.album_id
join invoice_line on track.track_id = invoice_line.track_id
group by artist.artist_id
order by sum(invoice_line.unit_price*invoice_Line.quantity) desc;

Q2 we want to find out the most popular music genre for each country we determine the most popular genre as the genre with the highesst 
amount of purchase.write a query that rturns each country along with the top genre for countries where the maaximum number of purchase is shared 
return all genres?
with popular_genre as
(
 select count(il.quantity) as purchased_quantity, billing_country,genre.name,genre.genre_id,
 row_number() over(partition by billing_country order by count(il.quantity) desc) as rows_number
 from invoice join invoice_line il on invoice.invoice_id = il.invoice_id join
 track on il.track_id = track.track_id join genre on
 track.genre_id = genre.genre_id
 group by 2,3,4
 order by 2 asc, 1 desc
 )
 select * from popular_genre 
 where rows_number <= 1;
 
 Q3 write a query that determines the customer that has spend the most on music for each country.write a query that reutrn the 
 country along with the top customer and how much they spent for countries where the top amount spent is shared,provide all customers 
 who spend this amount?
 
 with cte as(
 select sum(invoice.total) as total_amount_spend,invoice.billing_country,c.first_name,c.last_name,
 row_number() over(partition by invoice.billing_country order by sum(invoice.total) desc) as rows_number 
 from customer c
 join invoice on c.customer_id = invoice.customer_id
 group by 2,3
 order by 1 desc, 2 asc)
 select * from cte where rows_number = 1;




