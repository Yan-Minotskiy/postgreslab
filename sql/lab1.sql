--1. Вывести количество перелетов по каждой модели самолёта.
SELECT aircrafts_data.model ->> ‘en’ as Model, COUNT(flight_id) FROM flights
JOIN aircrafts_data ON flights.aircraft_code = aircrafts_data.aircraft_code
GROUP BY aircrafts_data.model
ORDER BY COUNT(flight_id) DESC;

--2. Вывести количество перелетов для каждого пассажира.
SELECT tickets.passenger_name, COUNT(flight_no) FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
GROUP BY tickets.passenger_name
HAVING COUNT(flight_no)>100
ORDER BY COUNT(flight_no) DESC;

--3. Вывести "многолётных" Иванов.
SELECT tickets.passenger_name, COUNT(flight_no) FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
WHERE tickets.passenger_name LIKE 'IVAN %'
GROUP BY tickets.passenger_name
HAVING COUNT(flight_no)>100 
ORDER BY COUNT(flight_no) DESC;

--4. Вывести все модели самолётов, которые прилетали в Домодедово.
SELECT flights.aircraft_code, COUNT(aircraft_code)  FROM flights
WHERE flights.departure_airport LIKE 'DME'
GROUP BY flights.aircraft_code
ORDER BY COUNT(aircraft_code) DESC;

--5. Вывести всех с именем на букву П, кто был в Якутске.
SELECT tickets.passenger_name FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
WHERE flights.departure_airport LIKE 'YKS' AND tickets.passenger_name LIKE 'P%';

--6. Вывести количество совершённых Натальей Ивановой полётов.
SELECT tickets.passenger_name, COUNT(flight_no) FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
WHERE tickets.passenger_name = 'NATALYA IVANOVA'
GROUP BY tickets.passenger_name;

--7. Вывести тех, кто вылетел из Внуково в Петрозаводск.
SELECT tickets.passenger_name FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
WHERE flights.departure_airport = 'VKO' AND flights.arrival_airport = 'PES'
AND flights.status = 'Arrived';

--8. Вывести количество прилетевших самолетов в Казань в августе 2017.
SELECT COUNT(arrival_airport) FROM flights
WHERE flights.arrival_airport = 'KZN'
AND to_char(flights.actual_departure, 'YYYY-MM') = '2017-08';

--9. Вывести сумму, на которую заказали пассажиры в промежутке c 10 по 20 августа.
SELECT SUM(bookings.total_amount) FROM bookings
WHERE bookings.book_date  BETWEEN '2017-08-10' and '2017-08-20';

--10. Сколько пассажиров в перелете Домодедово - Пулково 2017-07-16.
SELECT count(ticket_flights.ticket_no) FROM ticket_flights
JOIN flights ON ticket_flights.flight_id = flights.flight_id
WHERE flights.departure_airport = 'DME'
AND flights.arrival_airport = 'LED'
AND flights.flight_no = 'PG0405'
AND to_char(flights.actual_departure, 'YYYY-MM-DD') = '2017-07-16';

--11. Вывести количество пассажиров со счастливым билетом.
SELECT COUNT(boarding_passes.boarding_no) FROM boarding_passes
WHERE boarding_passes.boarding_no = '1' 
OR boarding_passes.boarding_no = '111'
OR boarding_passes.boarding_no = '222'
OR boarding_passes.boarding_no = '333';

--12. Вывести самый долгий перелет.
SELECT flights.actual_arrival - flights.actual_departure as interval, flights.flight_no  FROM flights
WHERE flights.status = ‘Arrived’
ORDER BY interval  DESC
limit 1;

--13. Самый загруженный аэропорт по приземлению.
SELECT  flights.arrival_airport, COUNT(arrival_airport)  FROM flights
GROUP BY flights.arrival_airport
ORDER BY COUNT(arrival_airport)  DESC
limit 1;

--14. Когда и кем сделано первое бронирование на Домодедово - Пулково 2017-07-16?
SELECT bookings.book_date, passenger_name FROM bookings
JOIN tickets ON bookings.book_ref = tickets.book_ref
JOIN ticket_flights ON tickets.ticket_no = ticket_flights.ticket_no
JOIN flights ON ticket_flights.flight_id = flights.flight_id
WHERE flights.flight_no = ‘PG0405’
AND to_char(flights.actual_departure, 'YYYY-MM-DD') = ‘2017-07-16’
ORDER BY bookings.book_date
limit 1;

--15. Какое максимальное количество пассажиров находилось в воздухе в одном самолете?
SELECT boarding_no FROM boarding_passes
ORDER BY boarding_no DESC
limit 1;

--16. Топ 100 самых дорогих заказов.
SELECT total_amount, passenger_name, arrival_airport  FROM bookings
JOIN tickets ON bookings.book_ref = tickets.book_ref
JOIN ticket_flights ON tickets.ticket_no = ticket_flights.ticket_no
JOIN flights ON ticket_flights.flight_id = flights.flight_id
ORDER BY total_amount DESC
limit 100;

--17. Средняя стоимость билета.
SELECT SUM(total_amount)/COUNT(total_amount) as medium  FROM bookings;

--18. Наибольшее количество перелетов между двумя городами.
SELECT DISTINCT flights.departure_airport, flights.arrival_airport, COUNT(flights.departure_airport) FROM flights
GROUP BY flights.departure_airport, flights.arrival_airport
ORDER BY COUNT(flights.departure_airport) DESC
limit 1; 

--19. Выведем билеты с ценой от 100 000 до 200 000
SELECT passenger_name, bookings.total_amount FROM tickets
JOIN bookings ON bookings.book_ref = tickets.book_ref
WHERE bookings.total_amount BETWEEN 100000 and 200000;

--20. Вывести модель с самым большим range.
SELECT aircrafts_data.model ->> ‘en’, range FROM aircrafts_data
ORDER BY range  DESC
limit 1;