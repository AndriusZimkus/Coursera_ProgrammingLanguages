(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw3d.sml";
    
val test1a = only_capitals ["A","B","C"] = ["A","B","C"]
val test1b = only_capitals ["ant","Bed","cant"] = ["Bed"]
val test1c = only_capitals ["ant","bed","cant"] = []
						      
val test2a = longest_string1 ["a","bc","C"] = "bc"
val test2b = longest_string1 ["a","bc","Cqwe"] = "Cqwe"
val test2c = longest_string1 ["a","bc","Cqwe", "1234"] = "Cqwe"						     
						     
val test3a = longest_string2 ["A","bc","C"] = "bc"
val test3b = longest_string2 ["a","bc","Cqwe"] = "Cqwe"
val test3c = longest_string2 ["a","bc","Cqwe", "1234"] = "1234"
							     
val test4a = longest_string3 ["A","bc","C"] = "bc"
val test4b = longest_string3 ["a","bc","Cqwe", "1234"] = "Cqwe"
val test4c = longest_string3 ["A","B","C"] = "A"

							     
val test4d = longest_string4 ["A","B","C"] = "C"
val test4e = longest_string4 ["a","bc","Cqwe", "1234"] = "1234"


val test5a = longest_capitalized ["A","bc","C"] = "A"
val test5b = longest_capitalized ["A","bc","C", "ABC"] = "ABC"
val test5c = longest_capitalized ["A","bc","C", "ABC","1234"] = "ABC"
						     

val test6a = rev_string "abc" = "cba"
val test6b = rev_string "123456" = "654321"
val test6c = rev_string "" = ""

val test7a = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test7b = ((first_answer (fn x => if x > 5 then SOME x else NONE) [1,2,3,4,5]; false)
	      handle NoAnswer => true)

val test8a = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8b = all_answers (fn x => if x = 2 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
											
val test9a1 = count_wildcards Wildcard = 1
val test9a2 = count_wildcards UnitP = 0
val test9a3 = count_wildcards (TupleP [Wildcard,Wildcard]) = 2

val test9b1 = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b2 = count_wild_and_variable_lengths (Variable("abc123")) = 6
val test9b3 = count_wild_and_variable_lengths (TupleP [Wildcard,Wildcard]) = 2

val test9c = count_some_var ("x", Variable("x")) = 1

val test10a = check_pat (Variable("x")) = true
val test10b = check_pat (TupleP[Variable("x"),Variable("x")]) = false
val test10c = check_pat (Wildcard) = true
val test10d = check_pat (TupleP[Variable("x"),Variable("y")]) = true
val test10e = check_pat (ConstructorP ("hi",TupleP[Variable "x",Variable "x"])) = false
val test10f = check_pat ( ConstructorP ("hi",TupleP[Variable "x",ConstructorP ("yo",TupleP[Variable "x",UnitP])])) = false
								    

								    

val test11 = match (Const(1), UnitP) = NONE

val test12 = first_match Unit [UnitP] = SOME []						   
