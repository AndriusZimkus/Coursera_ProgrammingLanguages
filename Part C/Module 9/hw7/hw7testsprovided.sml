(* University of Washington, Programming Languages, Homework 7
   hw7testsprovided.sml *)
(* Will not compile until you implement preprocess and eval_prog *)

(* These tests do NOT cover all the various cases, especially for intersection *)

use "hw7.sml";

(* Must implement preprocess_prog and Shift before running these tests *)

fun real_equal(x,y) = Real.compare(x,y) = General.EQUAL;

(* Preprocess tests *)
let
	val Point(a,b) = preprocess_prog(LineSegment(3.2,4.1,3.2,4.1))
	val Point(c,d) = Point(3.2,4.1)
in
	if real_equal(a,c) andalso real_equal(b,d)
	then (print "preprocess converts a LineSegment to a Point successfully\n")
	else (print "preprocess does not convert a LineSegment to a Point succesfully\n")
end;

let 
	val LineSegment(a,b,c,d) = preprocess_prog (LineSegment(3.2,4.1,~3.2,~4.1))
	val LineSegment(e,f,g,h) = LineSegment(~3.2,~4.1,3.2,4.1)
in
	if real_equal(a,e) andalso real_equal(b,f) andalso real_equal(c,g) andalso real_equal(d,h)
	then (print "preprocess flips an improper LineSegment successfully\n")
	else (print "preprocess does not flip an improper LineSegment successfully\n")
end;

(* eval_prog tests with Shift*)
let 
	val Point(a,b) = (eval_prog (preprocess_prog (Shift(3.0, 4.0, Point(4.0,4.0))), []))
	val Point(c,d) = Point(7.0,8.0) 
in
	if real_equal(a,c) andalso real_equal(b,d)
	then (print "eval_prog with empty environment worked\n")
	else (print "eval_prog with empty environment is not working properly\n")
end;

(* Using a Var *)
let 
	val Point(a,b) = (eval_prog (Shift(3.0,4.0,Var "a"), [("a",Point(4.0,4.0))]))
	val Point(c,d) = Point(7.0,8.0) 
in
	if real_equal(a,c) andalso real_equal(b,d)
	then (print "eval_prog with 'a' in environment is working properly\n")
	else (print "eval_prog with 'a' in environment is not working properly\n")
end;


(* With Variable Shadowing *)
let 
	val Point(a,b) = (eval_prog (Shift(3.0,4.0,Var "a"), [("a",Point(4.0,4.0)),("a",Point(1.0,1.0))]))
	val Point(c,d) = Point(7.0,8.0) 
in
	if real_equal(a,c) andalso real_equal(b,d)
	then (print "eval_prog with shadowing 'a' in environment is working properly\n")
	else (print "eval_prog with shadowing 'a' in environment is not working properly\n")
end;

(* My tests *)
print "Test 1 - points close\n";
let
    val Point(a,b) = Point(0.0,0.0);
    val Point(c,d) = Point(0.0000001,0.0);
in
    if real_close_point (a,b) (c,d)
    then (print "Correct - Points are correctly close\n")
    else (print "Incorrect - points should be close\n")
end;

print "Test 2 - point close to itself\n";
let
    val x = Point(0.0, 0.0);
    val Point(x1, y1) = x;
in
    if real_close_point (x1,y1) (x1,y1)
    then (print "Correct - x is correctly close\n")
    else (print "Incorrect - x should be close to itself\n")
end;

print "Test 3 - point close to itself\n";
let
    val x = Point(0.0, 0.0);
in
    if case x of Point(p) => real_close_point p p 
	      | _  => false
    then (print "Correct - x is correctly close\n")
    else (print "Incorrect - x should be close to itself\n")
end;

print "Test 4 - point not close to other point\n";
let
    val Point(a,b) = Point(0.0, 0.0);
    val Point(c,d) = Point(1.0,2.0);
in
    if not (real_close_point (a,b) (c,d))
    then (print "Correct - Points are not close\n")
    else (print "Incorrect - Points should not be close\n")
end;

print "Test 5 - preprocess and evaluate Shift\n";
let
    val LS = LineSegment(1.0,2.0,1.0,2.0);
    val s = Shift(10.0,20.0, LS);
    val actual = eval_prog(preprocess_prog(s),[]);
    val expected = Point(11.0,22.0);
in
    if case(actual,expected) of (Point(p1), Point(p2)) => real_close_point p1 p2
			      | _  => false
    then (print "Correct - actual is a point close to expected\n")
    else (print "Incorrect - actual is either not a point or not close to expected\n")    
end;
