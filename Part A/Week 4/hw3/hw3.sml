(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(*1*)
fun only_capitals stringList =
    List.filter ( fn s => Char.isUpper(String.sub(s,0) ) ) stringList

(*2*)
fun longest_string1 stringList =
    foldl
	(fn (s,x) => if String.size s > String.size x then s else x)
	""
	stringList

(*3*)
fun longest_string2 stringList =
    foldl
	(fn (s,x) => if String.size s >= String.size x then s else x)
	""
	stringList

(*4*)
fun longest_string_helper f string_list =
    foldl (fn (s1, s2) => if f(String.size s1, String.size s2) then s1 else s2) "" string_list
	
fun longest_string3 stringList =
    longest_string_helper (fn(x,y)=> x>y) stringList
			  
fun longest_string4 stringList =
    longest_string_helper (fn(x,y)=> x>=y) stringList

(*5*)
val longest_capitalized = fn string_list => (longest_string3 o only_capitals) string_list
					 
(*6*)
fun rev_string string = 0

			    (*7*)
					 (*8*)
					 (*9*)
					 (*10*)
					 (*11*)
					 (*12*)
					
