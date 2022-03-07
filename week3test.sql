CREATE TYPE enum_type AS ENUM ('completed', 'cancelled_by_driver', 'cancelled_by_client');
CREATE TYPE enum_role AS ENUM('client', 'driver', 'partner');
Create table If Not Exists Trips (id int, client_id int, driver_id int, city_id int, status enum_type, request_at varchar(50),
								 FOREIGN KEY(client_id) REFERENCES Users(users_id),
								 FOREIGN KEY(driver_id) REFERENCES Users(users_id));
Create table Users (users_id int, banned varchar(50), role enum_role, PRIMARY KEY(users_id));

Truncate table Trips;

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');


Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

Select users_id, banned, role, status, request_at From Trips Inner Join Users
On Users.users_id = Trips.client_id;

With cte As(Select users_id, banned, role, status, request_at From Trips Inner Join Users
On Users.users_id = Trips.client_id), cte2 AS(
Select request_at, count(Case when cte.banned = 'No' Then 'ok' End) As total_requests,
	count(Case when (cte.status = 'cancelled_by_driver' or cte.status = 'cancelled_by_client') and cte.banned = 'No' Then 'yes' End) As cancelled_rides 
	From cte Group By request_at Order by request_at)
Select request_at As day,
Round(cancelled_rides/total_requests::decimal, 2) As cancellation_rate From cte2;