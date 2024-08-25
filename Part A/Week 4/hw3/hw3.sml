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
	(fn (s,sofar) => if String.size s > String.size sofar then s else sofar)
	""
	stringList

(*3*)
fun longest_string2 stringList =
    foldl
	(fn (s,x) => if String.size s >= String.size x then s else x)
	""
	stringList

(*4*)
fun longest_string_helper f stringList =
    foldl
	(fn (s,x) => if f (String.size s, String.size x) then s else x)
	""
	stringList

	
fun longest_string3 stringList =
    longest_string_helper (fn (x1,x2)=> x1 > x2) stringList
			  
			  
fun longest_string4 stringList =
    longest_string_helper (fn (x1,x2)=> x1 >= x2) stringList

(*5*)
val longest_capitalized =
    (longest_string1 o only_capitals)
	
	
(*6*)
fun rev_string string =
    (implode o rev o explode) string

(*7*)
fun first_answer f someList =
    let
	val initial = foldl (fn (s,x) => if isSome x then x else f(s))
			    NONE
			    someList
    in
	if isSome initial then valOf initial else raise NoAnswer
    end
    
(*8*)
fun all_answers f mainList =
    let
	fun all_answers_helper (xs, acc) =
	    case xs of
		[] => SOME acc
	      | x::xs' => case f x of
			      NONE => NONE 
			    | SOME listOfxs => all_answers_helper(xs',listOfxs@acc) 
    in
	all_answers_helper(mainList,[])
    end
	
(*9a*)
fun count_wildcards patternToCheck =
    g (fn() => 1) (fn(x) => 0) patternToCheck

(*9b*)
fun count_wild_and_variable_lengths patternToCheck =
    g(fn() => 1) (fn(x) => String.size(x)) patternToCheck

(*9c*)
fun count_some_var (s,patternToCheck) =
    g (fn() => 0) (fn(x) => if s = x then 1 else 0) patternToCheck

(*10*)
fun check_pat patternToCheck =
    let
	fun getStringListFromPattern p =
		case p of
		    Wildcard   => []
		  | Variable x => [x]
		  | TupleP ps  => List.foldl ( fn (p,i) => i @ ( getStringListFromPattern  p) ) [] ps
		  | ConstructorP(s,x) => getStringListFromPattern(x)
		  | _ => [] 
								 

	fun hasRepeatsStringList xs =
	    case xs of
		[] => false 
	      | x::xs'  => (List.exists ( fn(y) => x=y ) xs') orelse (hasRepeatsStringList xs') 
	    					  			    
    in
	not ( hasRepeatsStringList(getStringListFromPattern(patternToCheck)))
    end

	
(*11*)
fun match (v,p) =
    case (v,p) of
	(_,Wildcard) => SOME []
     |  (v, Variable s) => SOME [(s,v)]
     |  (Unit, UnitP) => SOME []
     |  (Const x, ConstP y) => if x = y then SOME[] else NONE 
     |  (Tuple valueList, TupleP patternList) =>
	  if length valueList = length patternList
	  then all_answers match (ListPair.zip (valueList, patternList))
	  else NONE
     |  (Constructor (s1,v), ConstructorP(s2,p)) => if s1=s2 then match(v,p) else NONE
     |  (_,_) => NONE

(*12*)
fun first_match v listOfPatterns =
    SOME (first_answer ( fn(p) =>  match(v,p)) listOfPatterns ) handle NoAnswer => NONE
					
