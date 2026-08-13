INSERT INTO trips(trip_id,rider_id,driver_id,trip_date,pickup_location,drop_location,distance_km,fare,trip_status,payment_method)
VALUES(1001,1,101,'2025-01-05 09:15:00','Andheri','Bandra',12.50,420.00,'Completed','UPI'),
      (1002,2,102,'2025-01-05 18:30:00','Connaught Place','Noida',18.00,650.00,'Completed','Card'),
	  (1003,3,103,'2025-01-06 08:45:00','Hinjewadi','Shivajinagar',15.20,390.00,'Cancelled','Cash'),
	  (1004,4,104,'2025-01-06 20:10:00','Whitefield','MG Road',20.50,720.00,'Completed','UPI');
GO

SELECT * FROM dbo.trips;
