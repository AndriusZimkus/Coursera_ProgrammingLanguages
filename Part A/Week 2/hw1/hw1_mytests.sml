(*is_older*)
(*example test*)
val test11 = is_older ((1,2,3),(2,3,4)) = true
(*later year*)					    
val test12 = is_older ((2024,10,5),(2020,11,6)) = false
(*earlier year*)			     
val test13 = is_older ((1,2,3),(3,2,1)) = true

(*same year, later month*)				     
val test14 = is_older ((1,4,3),(1,2,4)) = false
(*same year, earlier month*)
val test15 = is_older ((1,2,3),(1,3,4)) = true
					     
(*same year, same month, later day*)
val test16 = is_older ((1,2,5),(1,2,4)) = false
(*same year, same month, earlier day*)
val test17 = is_older ((1,2,3),(1,2,4)) = true
					     
(*same date*)
val test18 = is_older ((1,2,3),(1,2,3)) = false

					      
(*number_in_month*)
(*example test*)					     
val test21 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1

(*empty list*)								
val test22 = number_in_month ([],1) = 0

(*longer list*)				  
val test23 = number_in_month (
	[(2021,10,1),(2022,10,2),(2023,1,1),(2024,10,8),(1999,5,5),(1995,10,3)],
	10)
	     = 4

(*none in month*)
val test24 = number_in_month ([(2021,1,1),(2022,2,1)],3) = 0

							       
(*number_in_months*)
(*example test*)
val test31 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3

(*empty list of dates*)
val test32 = number_in_months ([],[2,3,4]) = 0
						 
(*empty list of months*)
val test33 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = 0
											   
(*dates with month repetitions*)
val test34 = number_in_months ([(2012,8,28),(2013,1,1),(2011,2,31),(2011,4,28),(2011,8,28),(2010,8,1),(1999,4,9) ],[4,5,8]) = 5											
																  
																  
(*dates_in_month*)
val test41 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]

(*empty list*)								
val test42 = dates_in_month ([],1) = []

(*longer list*)				  
val test43 = dates_in_month (
	[(2021,10,1),(2022,10,2),(2023,1,1),(2024,10,8),(1999,5,5),(1995,10,3)],
	10)
	     = [(2021,10,1),(2022,10,2),(2024,10,8),(1995,10,3)]

(*none in month*)
val test44 = dates_in_month ([(2021,1,1),(2022,2,1)],3) = []


(*dates_in months*)
val test51 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

(*empty list of dates*)
val test52 = dates_in_months ([],[2,3,4]) = []
						 
(*empty list of months*)
val test53 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = []
											   
(*dates with month repetitions*)
val test54 = dates_in_months (
	[(2012,8,28),(2013,1,1),(2011,2,31),(2011,4,28),(2011,8,28),(2010,8,1),(1999,4,9)],[4,5,8])
	= [(2011,4,28),(1999,4,9),(2012,8,28),(2011,8,28),(2010,8,1)]	 

	      
val test61 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test62 = get_nth (["hi", "there", "how", "are", "you"], 5) = "you"
					     
							     
val test71 = date_to_string (2013, 6, 1) = "June 1, 2013"
val test72 = date_to_string (2020, 12, 30) = "December 30, 2020"
					       
val test81 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test82 = number_before_reaching_sum (15, [1,2,3,4,5]) = 4
val test83 = number_before_reaching_sum (5, [10,2,3,4,5]) = 0				

val test91 = what_month 70 = 3
val test92 = what_month 1  = 1
val test93 = what_month 365 = 12

val test101 = month_range (31, 34) = [1,2,2,2]
val test102 = month_range (34, 31) = []
val test103 = month_range (331,335) = [11,11,11,11,12] 
				
val test111 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test112 = oldest([(1999,1,1),(2011,3,31),(2011,4,28)]) = SOME (1999,1,1)
val test113 = oldest([(1999,1,1),(2011,3,31),(1800,12,28)]) = SOME (1800,12,28)

(*number_in_months_challenge*)
(*example test*)
val test1211 = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,3,4]) = 3

(*empty list of dates*)
val test1212 = number_in_months_challenge ([],[2,3,4]) = 0
						 
(*empty list of months*)
val test1213 = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = 0
											   
(*dates with month repetitions*)
val test1214 = number_in_months_challenge ([(2012,8,28),(2013,1,1),(2011,2,31),(2011,4,28),(2011,8,28),(2010,8,1),(1999,4,9) ],[4,5,8]) = 5	

(*dates_in months_challenge*)
val test1221 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

(*empty list of dates*)
val test1222 = dates_in_months_challenge ([],[2,3,4]) = []
							   
(*empty list of months*)
val test1223 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = []
												     
(*dates with month repetitions*)
val test1224 = dates_in_months_challenge (
	[(2012,8,28),(2013,1,1),(2011,2,31),(2011,4,28),(2011,8,28),(2010,8,1),(1999,4,9)],[4,5,8])
	      = [(2011,4,28),(1999,4,9),(2012,8,28),(2011,8,28),(2010,8,1)]	 

		    
val test131 = reasonable_date (2000,12,1) = true
val test132 = reasonable_date (~5,12,1) = false
val test133 = reasonable_date (2000,~10,1) = false
val test134 = reasonable_date (2000,13,1) = false				    
val test135 = reasonable_date (2024,1,31) = true
val test136 = reasonable_date (2024,4,31) = false
val test137 = reasonable_date (2024,2,29) = true
val test138 = reasonable_date (2000,2,29) = true
val test139 = reasonable_date (1900,2,29) = false

