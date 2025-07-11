(* CSE 341, Homework 2 Tests *)
open Hw2
open Hw2challenge
open Json

(* This file provides a list of basic tests for your homework.
 * You will surely want to add more! These tests do not guarantee that your code
 * is correct or will pass autograder tests. 
 * Notice that currently calling any of the functions on hw2.ml will fail,
 * as such, all test functions are commented by default. As you
 * work on implementing the homework functions:
 *   1. Implement the changes on hw2.ml
 *   2. Run `dune build` to make sure everything compiles
 *   3. Uncomment the corresponding test
 *   4. Add more test scenarios
 *   5. Run `dune test` to build and run your tests.
 * If working correctly, `dune test` will complete with no error messages
 *)

(* We leave the first test uncommented to get you started. Until make_silly_json
 * gets implemented, calling `dune test` or `#use "hw2test.ml"` from dune utop 
 * will print a Failure message: *)
 let%test "test1" = 
  make_silly_json 2 
  = 
  Array
    [Object [("n", Num 2.); ("b", True)]; 
     Object [("n", Num 1.); ("b", True)]]

(*Problem 2: concat_with*)
let%test "test2" = concat_with (";", ["1"; "2"]) = "1;2"
(* Test with a longer list and a different separator *)
let%test "test2b" = concat_with (" ", ["OCaml"; "is"; "fun"]) = "OCaml is fun"
(* Test the first base case: an empty list *)
let%test "test2c" = concat_with (",", []) = ""
(* Test the second base case: a single-element list *)
let%test "test2d" = concat_with (",", ["hello"]) = "hello"

(*Problem 3: quote_string *)
let%test "test3" = quote_string "hello" = "\"hello\""

(*Problem 4: string_of_json *)
let%test "test4" = string_of_json json_obj = "{\"foo\" : 3.14159, \"bar\" : [1, \"world\", null], \"ok\" : true}"
(* Test an empty object *)
let%test "string_of_json: empty object" = string_of_json (Object []) = "{}"
(* Test an empty array *)
let%test "string_of_json: empty array" = string_of_json (Array []) = "[]"

(*Problem 5: string_of_json *)
let%test "test5" = take (2, [4; 5; 6; 7]) = [4; 5]
(* Test the base case where n is 0 *)
let%test "take: n is zero" =
  take (0, [4; 5; 6; 7]) = []
(* Test taking all elements from a list *)
let%test "take: all elements" =
  take (3, ["a"; "b"; "c"]) = ["a"; "b"; "c"]
(* Test taking from a single element list *)
let%test "take: single-element list" =
  take (1, [99]) = [99]

(* Problem 6: firsts *)
let%test "test6" = firsts [(1,2); (3,4)] = [1; 3]
(* Test the base case with an empty list *)
let%test "firsts: empty list" =
  firsts [] = []
(* Test a list with a single pair *)
let%test "firsts: single element list" =
  firsts [("hello", 100)] = ["hello"]
(* Test a list of pairs with different types *)
let%test "firsts: string and bool pairs" =
  firsts [("a", true); ("b", false); ("c", true)] = ["a"; "b"; "c"]

(** don't forget to write a comment for problem 7 **)

(* Problem 8: assoc *)
let%test "test8" = assoc ("foo", [("bar",17);("foo",19)]) = Some 19
(* Test the case where the key is not found in the list *)
let%test "assoc: key not found" = 
  assoc ("c", [("a", 1); ("b", 2)]) = None

(* Problem 9: dot *)
let%test "test9" = dot (json_obj, "ok") = Some True
(* A sample object to use for testing *)
let dot_test_obj = Object [("name", String "Alice"); ("age", Num 30.0); ("is_active", True)]
(* This is the success case *)
let%test "dot: success" =
  dot (dot_test_obj, "is_active") = Some True
(* This test checks the case where the field does not exist in the object. *)
let%test "dot: field does not exist" =
  dot (dot_test_obj, "email") = None
(* This test checks the case where the input json is not an object. *)
let%test "dot: not an object" =
  dot (Array [], "name") = None

(* Problem 10: dots *)
let%test "test10" = dots (Object [("f", Object [("g", String "gotcha")])], ["f"; "g"]) = Some (String "gotcha")
(* A nested object for testing *)
let dots_test_obj =
  Object [
    ("user", Object [
      ("name", String "Bob");
      ("address", Object [
        ("city", String "Seattle")
      ])
    ]);
    ("data", Array [])
  ]
(* Test a successful, multi-level path *)
let%test "dots: success" =
  dots (dots_test_obj, ["user"; "address"; "city"]) = Some (String "Seattle")
(* Test a path that fails because a field is missing *)
let%test "dots: invalid field" =
  dots (dots_test_obj, ["user"; "address"; "zip"]) = None
(* Test a path that fails because it tries to traverse through a non-object *)
let%test "dots: path through non-object" =
  dots (dots_test_obj, ["data"; "name"]) = None
(* Test the base case with an empty path list *)
let%test "dots: empty path" =
  dots (dots_test_obj, []) = Some dots_test_obj

(* Problem 11: one_fields *)
let%test "test11" = sort (one_fields json_obj) = sort ["foo";"bar";"ok"]
let fields_test_obj = Object [("name", String "Alice"); ("age", Num 30.)]
(* Test a standard object, sorting the lists to ensure order doesn't matter. *)
let%test "one_fields: standard object" =
  sort (one_fields fields_test_obj) = sort ["name"; "age"]
(* Test an empty object, should produce an empty list. *)
let%test "one_fields: empty object" =
  one_fields (Object []) = []
(* Test a non-object value, should also produce an empty list. *)
let%test "one_fields: not an object" =
  one_fields (Array []) = []

(* Problem 12: no_repeats *)
let%test "test12" = not (no_repeats ["foo";"bar";"foo"])
(* Test a list with duplicates, should return false. *)
let%test "no_repeats: has duplicates" =
  no_repeats ["a"; "b"; "a"] = false
(* Test a list with no duplicates, should return true. *)
let%test "no_repeats: no duplicates" =
  no_repeats [1; 2; 3] = true
(* Test an empty list, which has no duplicates. *)
let%test "no_repeats: empty list" =
  no_repeats [] = true
(* Test a single-element list, which has no duplicates. *)
let%test "no_repeats: single element" =
  no_repeats ["hello"] = true

(* Problem 13: recursive_no_field_repeats *)
let nest = Array [Object [];
                  Object[("a",True);
                         ("b",Object[("foo",True);
                                     ("foo",True)]);
                         ("c",True)];
                  Object []]
let%test "test13" = not (recursive_no_field_repeats nest)
(* A nested object that should pass. *)
let valid_nest =
  Object
    [ ("a", True);
      ("b", Array [Object [("x", True)]; Object [("y", True)]]);
      ("c", Object [("z", True)]) ]
let%test "recursive_no_field_repeats: complex passing case" =
  recursive_no_field_repeats valid_nest
(* A simple object with repeated fields that should fail. *)
let simple_fail = Object [("a", True); ("a", False)]
let%test "recursive_no_field_repeats: simple failing case" =
  not (recursive_no_field_repeats simple_fail)
(* A primitive value, which contains no objects and should pass. *)
let%test "recursive_no_field_repeats: primitive value" =
  recursive_no_field_repeats (Num 42.0)

(* Problem 14: count_occurrences *)
(* Any order is allowed by the specification, so it's ok to fail this test because of a different order. 
   You can edit this test to match your implementation's order. *)
let%test "test14a" = count_occurrences (["a"; "a"; "b"]) = [("a", 2);("b", 1)]
(* Test a list with several groups of strings. *)
let%test "count_occurrences: multiple groups" =
  count_occurrences ["a"; "a"; "b"; "c"; "c"; "c"] = [("a", 2); ("b", 1); ("c", 3)]
(* Test the base case with an empty list. *)
let%test "count_occurrences: empty list" =
  count_occurrences [] = []
(* Test a list where all elements are the same. *)
let%test "count_occurrences: all same" =
  count_occurrences ["x"; "x"; "x"] = [("x", 3)]
(* Test a list with no duplicates. *)
let%test "count_occurrences: no duplicates" =
  count_occurrences ["a"; "b"; "c"] = [("a", 1); ("b", 1); ("c", 1)]

(* Problem 15: string_values_for_access_path *)
let%test "test15" = string_values_for_access_path (["x"; "y"], [Object [("a", True);("x", Object [("y", String "foo")])];
                                                             Object [("x", Object [("y", String "bar")]); ("b", True)]])
            = ["foo";"bar"]
(* A list of various JSON objects for testing *)
let path_test_data =
  [
    Object [("a", Object [("b", String "ok")])];     (* Match *)
    Object [("a", Object [("b", Num 1.0)])];        (* Path is valid, but not a string *)
    Object [("x", String "y")];                      (* Path is not valid *)
    Object [("a", Object [("b", String "go")])];     (* Match *)
    Object [("a", Object [("b", String "ok")])]      (* Duplicate match *)
  ]
(* Test a complex case with matches, non-matches, and duplicates. *)
let%test "string_values_for_access_path: complex case" =
  let result = string_values_for_access_path (["a"; "b"], path_test_data) in
  sort result = ["go"; "ok"; "ok"]
(* Test the case where the input list is empty. *)
let%test "string_values_for_access_path: empty list" =
  string_values_for_access_path (["a"; "b"], []) = []
(* Test the case where no paths match. *)
let%test "string_values_for_access_path: no matches" =
  string_values_for_access_path (["x"; "y"], path_test_data) = []
    
(* Problem 16: filter_access_path_value *)
let%test "test16" = filter_access_path_value (["x"; "y"], "foo",
                                           [Object [("x", Object [("y", String "foo")]); ("z", String "bar")];
                                            Object [("x", Object [("y", String "foo")]); ("z", String "baz")];
                                            Object [("x", String "a")];
                                            Object []])
             = 
             [Object [("x", Object [("y", String "foo")]); ("z", String "bar")];
              Object [("x", Object [("y", String "foo")]); ("z", String "baz")]]
(* A list of various JSON objects for testing *)
let filter_test_data =
  [
    Object [("status", String "active"); ("id", Num 1.0)];
    Object [("status", String "inactive"); ("id", Num 2.0)];
    Object [("status", String "active"); ("id", Num 3.0)];
    Object [("status", Num 99.)] (* status is not a string here *)
  ]
(* Test a standard case where some items should be filtered. *)
let%test "filter_access_path_value: standard case" =
  let result = filter_access_path_value (["status"], "active", filter_test_data) in
  result =
    [ Object [("status", String "active"); ("id", Num 1.0)];
      Object [("status", String "active"); ("id", Num 3.0)] ]
(* Test the case where no items match the filter value. *)
let%test "filter_access_path_value: no matches" =
  filter_access_path_value (["status"], "archived", filter_test_data) = []
(* Test the case where the input list is empty. *)
let%test "filter_access_path_value: empty list" =
  filter_access_path_value (["status"], "active", []) = []

(* Problem 17: in_rect *)
let pgascse =
  { latitude = 47.653221;
    longitude = -122.305708 }

let%test "test17" = in_rect (u_district, pgascse)
(* A sample rectangle for testing. *)
let test_rect = {
  min_latitude  = 47.0;
  max_latitude  = 48.0;
  min_longitude = -122.0;
  max_longitude = -121.0
}
(* Test a point clearly inside the rectangle. *)
let%test "in_rect: point inside" =
  let p = { latitude = 47.5; longitude = -121.5 } in
  in_rect (test_rect, p)
(* Test a point on the boundary/edge (should be true). *)
let%test "in_rect: point on edge" =
  let p = { latitude = 47.0; longitude = -121.5 } in
  in_rect (test_rect, p)
(* Test a point on a corner (should be true). *)
let%test "in_rect: point on corner" =
  let p = { latitude = 48.0; longitude = -122.0 } in
  in_rect (test_rect, p)
(* Test a point clearly outside the rectangle. *)
let%test "in_rect: point outside" =
  let p = { latitude = 49.0; longitude = -121.5 } in
  not (in_rect (test_rect, p))

(* Problem 18: point_of_json*)
let json_pgascse = Object [("latitude", Num 47.653221); ("longitude", Num (-122.305708))]
let%test "test18" = point_of_json json_pgascse = Some pgascse
(* Test a case where a field is missing. *)
let%test "point_of_json: missing field" =
  let j = Object [("latitude", Num 47.0)] in
  point_of_json j = None
(* Test a case where a field has the wrong type. *)
let%test "point_of_json: wrong type" =
  let j = Object [("latitude", String "47.0"); ("longitude", Num (-122.0))] in
  point_of_json j = None
(* Test a case where the input is not a JSON object. *)
let%test "point_of_json: not an object" =
  point_of_json (Array []) = None

(* Tests for Problem 19: filter_access_path_in_rect *)
let pgascse = { latitude = 47.653221; longitude = -122.305708 }
let json_pgascse = Object [("latitude", Num 47.653221); ("longitude", Num (-122.305708))]
let json_outside = Object [("latitude", Num 0.0); ("longitude", Num 0.0)]
let rect_test_data =
  [
    Object [("location", json_pgascse)];
    Object [("location", json_outside)];
    Object [("loc", json_pgascse)];
    Object [("location", String "loc")]
  ]

let%test "test19" =
  filter_access_path_in_rect (["x"; "y"], u_district, [Object [("x", Object [("y", json_pgascse)])]; Object []])
  = [Object [("x", Object [("y", json_pgascse)])]]
(* Tests a mixed list to ensure only the valid item is kept. *)
let%test "filter_in_rect: mixed list" =
  let result = filter_access_path_in_rect (["location"], u_district, rect_test_data) in
  result = [Object [("location", json_pgascse)]]
(* Tests a point that is valid but outside the target rectangle. *)
let%test "filter_in_rect: point outside" =
  let test_list = [Object [("location", json_outside)]] in
  filter_access_path_in_rect (["location"], u_district, test_list) = []
(* Tests an item where the access path is invalid. *)
let%test "filter_in_rect: invalid path" =
  let test_list = [Object [("loc", json_pgascse)]] in
  filter_access_path_in_rect (["location"], u_district, test_list) = []
(* Tests the base case with an empty list of items. *)
let%test "filter_in_rect: empty list" =
  filter_access_path_in_rect (["location"], u_district, []) = []


(* Challenge problems *)

(* let%test "testC1" = consume_string_literal (char_list_of_string "\"foo\" : true") = ("foo", [' '; ':'; ' '; 't'; 'r'; 'u'; 'e']) *)

(* let%test "testC2" = consume_keyword (char_list_of_string "false foo") = (FalseTok, [' '; 'f'; 'o'; 'o']) *)

(* let%test "testC3" = tokenize_char_list (char_list_of_string "{ \"foo\" : 3.14, \"bar\" : [true, false] }")
             = [LBrace; StringLit "foo"; Colon; NumLit "3.14"; Comma; StringLit "bar";
                Colon; LBracket; TrueTok; Comma; FalseTok; RBracket; RBrace] *)

(* let%test "testC5" = parse_string [StringLit "foo"; FalseTok] = ("foo", [FalseTok]) *)

(* let%test "testC6" = expect (Colon, [Colon; FalseTok]) = [FalseTok] *)

(* let%test "testC10" = parse_json (tokenize "{ \"foo\" : null, \"bar\" : [true, false] }")
              = (Object [("foo", Null); ("bar", Array [True; False])], []) *)

