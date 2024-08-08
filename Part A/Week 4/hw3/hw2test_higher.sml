(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw2BY.sml";
    
val test1a1 = all_except_option ("string", ["string"]) = SOME []
val test1a2 = all_except_option ("string", ["string","a","b"]) = SOME ["a","b"]
val test1a3 = all_except_option ("string", ["a","b"]) = NONE
val test1a4 = all_except_option ("string", ["a","c","b","string","e"]) = SOME ["a","c","b","e"]
							  
val test1b1 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test1b2 = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
				 "Fred") = ["Fredrick","Freddie","F"]
val test1b3 = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],
				 "Jeff") = ["Jeffrey","Geoff","Jeffrey"]

val test1c1 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test1c2 = get_substitutions2 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
				  "Fred") = ["Fredrick","Freddie","F"]
val test1c3 = get_substitutions2 ([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],
				  "Jeff") = ["Jeffrey","Geoff","Jeffrey"]					       

val test1d1 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) =
	      [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	       {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]

val test2a1 = card_color (Clubs, Num 2) = Black
val test2a2 = card_color (Hearts, King) = Red

val test2b1 = card_value (Clubs, Num 2) = 2
val test2b2 = card_value (Hearts, Ace) = 11
val test2b3 = card_value (Clubs, King) = 10
					     
val test2c1 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test2c2 = remove_card ([(Hearts, King),(Hearts, Ace),(Spades, Num 5),(Diamonds, King)], (Hearts, Ace), IllegalMove) = [(Hearts, King),(Spades, Num 5),(Diamonds, King)]		    

val test2d1 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test2d2 = all_same_color [(Hearts, Ace), (Diamonds, Ace)] = true
val test2d3 = all_same_color [(Hearts, Ace), (Diamonds, Ace),(Spades, Num 10)] = false

val test2e1 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test2e2 = sum_cards [(Clubs, Num 2),(Clubs, Num 2),(Diamonds, Ace)] = 15
val test2e3 = sum_cards [] = 0

val test2f1 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test2f2 = score ([(Hearts, Num 2),(Clubs, Ace)],10) = 9
val test2f3 = score ([(Hearts, Num 6),(Diamonds, Ace)],10) = 10
val test2f4 = score ([(Hearts, Num 6),(Spades, Ace)],10) = 21

val test2g1 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test2g2 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                         [Draw,Draw,Draw,Draw,Draw],
                         42)
              = 3

val test2g3 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                          [Draw,Discard(Hearts,Jack)],
                          42);
		false) 
               handle IllegalMove => true)

val test2g4 = officiate ([(Clubs,Ace)],[Draw,Discard(Clubs,Ace)],20) = 10

								   
val test3a1 = score_challenge ([(Hearts, Ace),(Clubs, Num 4)], 15) = 0
val test3a2 = score_challenge ([(Hearts, Ace),(Clubs, Num 4)], 14) = 3
val test3a3 = score_challenge ([(Hearts, Ace),(Clubs, Num 4)], 4) = 3
val test3a4 = score_challenge ([(Hearts, Ace),(Clubs, Num 4), (Diamonds,Ace)], 4) = 6
val test3a5 = score_challenge ([(Hearts, Ace),(Clubs, Num 4), (Diamonds,Ace)], 20) = 4
val test3a6 = score_challenge ([(Hearts, Ace),(Clubs, Num 4), (Diamonds,Ace)], 100) = 74
									   

