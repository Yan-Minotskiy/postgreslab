SELECT tickets.passenger_name, COUNT(flight_no) FROM tickets
INNER JOIN ticket_flights ON ticket_flights.ticket_no=tickets.ticket_no
INNER JOIN flights ON ticket_flights.flight_id=flights.flight_id
GROUP BY tickets.passenger_name
HAVING COUNT(flight_no)>100
ORDER BY COUNT(flight_no) DESC;