(*
    In all problems, a date is an SML value of type int*int*int,
    where the first part is the year, the second part is the month,
    and the third part is the day.   
*)

(*1*)
fun is_older (firstDate:int*int*int, secondDate:int*int*int) =
    let
	val firstYear = (#1 firstDate)
	val firstMonth  = (#2 firstDate)
	val firstDay = (#3 firstDate)
	val secondYear = (#1 secondDate)
	val secondMonth = (#2 secondDate)
	val secondDay = (#3 secondDate)
			    
    in
	firstYear < secondYear
	orelse firstYear = secondYear andalso firstMonth < secondMonth
	orelse firstYear = secondYear andalso firstMonth = secondMonth andalso firstDay < secondDay	       
    end

(*2*)
fun number_in_month (listOfDates : (int*int*int) list, neededMonth : int) =
    foldl (fn(s,x) => if #2 s = neededMonth then x+1 else x) 0 listOfDates

(*3*)	    
fun number_in_months (listOfDates : (int*int*int) list, listOfNeededMonths : int list) =
    if null listOfDates orelse null listOfNeededMonths
    then 0
    else number_in_month(listOfDates, hd(listOfNeededMonths)) + number_in_months(listOfDates, tl(listOfNeededMonths))

(*4*)									
fun dates_in_month (listOfDates : (int*int*int) list, neededMonth : int) =
    if null listOfDates
    then []
    else
	let
	    val currentDate = hd(listOfDates)
	    val currentMonth = #2 currentDate
	    val restOfDates = if null (tl(listOfDates)) then [] else (dates_in_month(tl(listOfDates), neededMonth))
	in
	    if currentMonth = neededMonth
	    then (currentDate :: restOfDates)
	    else restOfDates
	end

(*5*)
fun dates_in_months (listOfDates : (int*int*int) list, listOfNeededMonths : int list) =
    if null listOfDates orelse null listOfNeededMonths
    then []
    else
	let
	    val currentMonth = hd(listOfNeededMonths)
	in
	    dates_in_month(listOfDates, currentMonth) @ dates_in_months(listOfDates, tl(listOfNeededMonths))
	end

(*6*)
fun get_nth (listOfStrings: string list, n : int) =
    if n = 1
    then hd(listOfStrings)
    else get_nth(tl(listOfStrings), n-1)

(*7*)
fun date_to_string (inputDate : int*int*int) =
    let
	val months = ["January", "February","March","April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
	get_nth(months, #2 inputDate) ^ " " ^ Int.toString(#3 inputDate) ^ ", " ^ Int.toString(#1 inputDate)
    end
	
(*8*)	
fun number_before_reaching_sum (sum : int, listOfInts: int list) =
    if null listOfInts
    then 0
    else
	if sum <= hd(listOfInts)
	then 0
	else 1 + number_before_reaching_sum(sum-hd(listOfInts), tl(listOfInts))

(*9*)
fun what_month (dayOfYear: int) =
    let
	val daysForMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    in
	number_before_reaching_sum(dayOfYear,daysForMonths)+1
    end

(*10*)
fun month_range (from : int, to : int) =
    if from > to
    then []
    else
	what_month(from) :: month_range(from+1, to)

(*11*)
fun oldest (listOfDates : (int*int*int) list) =
    if null listOfDates
    then NONE
    else
	let
	    fun oldest_helper (listOfDatesForHelper : (int*int*int) list, oldestDate_option : (int*int*int) option) =
		if null listOfDatesForHelper
		then oldestDate_option
		else
		    let
			val currentDate = hd(listOfDatesForHelper)
			val currentOldestDate_option =
			    if (not (isSome oldestDate_option) orelse is_older ( currentDate, valOf oldestDate_option))
			    then SOME (currentDate)
			    else oldestDate_option
				     
		    in
			oldest_helper (tl(listOfDatesForHelper),currentOldestDate_option)
		    end
			
	in
	    oldest_helper (listOfDates, NONE)
	end

(*12*)
fun valueExists (thisInt : int, thisIntList : int list) =
    if null thisIntList
    then false
    else
	if hd(thisIntList) = thisInt
	then true
	else (valueExists (thisInt, tl(thisIntList)))
		 
fun remove_duplicates (listOfInts : int list) =
    if null listOfInts
    then []
    else
	let
	    fun remove_duplicates_helper (listOfInts : int list, nonDuplicateIntList : int list) =
		if null listOfInts
		then nonDuplicateIntList
		else
		    if valueExists (hd(listOfInts), nonDuplicateIntList)
		    then (remove_duplicates_helper (tl(listOfInts),nonDuplicateIntList))
		    else (remove_duplicates_helper (tl(listOfInts), nonDuplicateIntList@[hd(listOfInts )]))			      
	in
	    remove_duplicates_helper(listOfInts, [])
	end	
	    
	    
fun number_in_months_challenge (listOfDates : (int*int*int) list, listOfNeededMonths : int list) =
    number_in_months (listOfDates, remove_duplicates (listOfNeededMonths))
		     
fun dates_in_months_challenge (listOfDates : (int*int*int) list, listOfNeededMonths : int list) =
    dates_in_months (listOfDates, remove_duplicates (listOfNeededMonths))

(*13*)	    
fun reasonable_date (inputDate : (int*int*int)) =
    let
	fun get_nth_int (listOfInts: int list, n : int) =
	    if null listOfInts
	    then 0
	    else
		if n = 1
		then hd(listOfInts)
		else get_nth_int(tl(listOfInts), n-1)
			    
	val year = (#1 inputDate)
	val month  = (#2 inputDate)
	val day  = (#3 inputDate)
	val isLeapYear =
	    if
		year mod 400 <> 0 andalso year mod 100 = 0
	    then
		false
	    else
		year mod 4 = 0 orelse year mod 400 = 0 
	val validDayCounts = [31,28,31,30,31,30,31,31,30,31,30,31]
	val currentMonthDayCount =
	    if
		isLeapYear andalso month = 2 
	    then
		29
	    else
		get_nth_int (validDayCounts, month)

	val isValidYear = year > 0
	val isValidMonth = month >= 1 andalso  month <= 12
	val isValidDay = day >=1 andalso day <= currentMonthDayCount
    in
	isValidYear andalso isValidMonth andalso isValidDay
    end
