(* mandeldraw.ml --- Plot a Mandelbrot set.
 * Copyright 2003 by Dave Pearson <davep@davep.org>
 * $Revision: 1.1 $
 * 
 * mandeldraw.ml is free software distributed under the terms of the GNU
 * General Public Licence, version 2. For details see the file COPYING.
 *
 * Commentary:
 * 
 * The following code is my first play with OCaml, it plots a Mandelbrot
 * set.
 *
 * TODO:
 *
 * o React to mouse input.
 * o All sorts of other improvements, too many to list here right now.
 * 
 *)

(* We need the code to do the mandelbrot calculations. *)
open Mandelbrot;;
(* We need graphics. *)
open Graphics;;
(* Make use of the sys library. *)
open Sys;;
(* We want to do some printing too. *)
open Printf;;

(* Default values. *)
let width      = 1024;;
let height     = 768;;
let resolution = 32;;
let max_colour = 256;;
let from_x     = (-2.5);;
let to_x       = 1.5;;
let from_y     = (-1.5);;
let to_y       = 1.5;;
let buffering  = 4;;

(* What to do when we're inside the set. *)
let inside x y i point resolution =
  set_color black;
  plot x y;;

(* What to do when we're outside the set. *)
let outside x y i point resolution = 
  let pickcolour i = (int_of_float ( ( (float_of_int max_colour) /. (float_of_int resolution) ) *. (float_of_int ( resolution - i )) )) in
  let r = pickcolour i in
  let g = if ( r mod 3 ) > 0 then r + 1 else r in
  let b = if ( r mod 3 ) > 1 then r + 1 else r in
    set_color (rgb r g b);
    plot x y;;

(* Open the window. *)
open_graph (sprintf " %dx%d" width height);;

(* Turn off auto sync. *)
auto_synchronize false;;

  (* Do some buffering of the output. *)
let each_x x =
  if ( x mod buffering ) = 0 then
    synchronize ();;

(* Don't do anything special in this case. *)
let each_y y = [];;

(* The main interface loop. *)
let from_x     = ref from_x     in
let to_x       = ref to_x       in
let from_y     = ref from_y     in
let to_y       = ref to_y       in
let resolution = ref resolution in
let redraw     = ref true       in
  
  while true do

    if !redraw then
      begin
        
        (* Give it a nice title. *)
        set_window_title (sprintf "OCaml Mandelbrot - %f->%f,%f->%f" !from_x !to_x !from_y !to_y);

        printf "Resolution: %d\n" !resolution;
        flush_all ();
        
        (* Off we go... *)
        let start = ( time() ) in
          begin
            mandelbrot !from_x !to_x !from_y !to_y width height !resolution inside outside each_x each_y;
            printf "Elapsed time: %f\n" ( ( time () ) -. start );
            flush_all ();
          end;
          
          (* Do the final flush of the image. *)
          synchronize ();

      end;

    (* Handle user input. *)
    let event = wait_next_event [ Key_pressed; Button_down ] in
    let zoom op by from_x to_x from_y to_y =
      from_x := (op) !from_x by;
      to_x   := (op) !to_x   by;
      from_y := (op) !from_y by;
      to_y   := (op) !to_y   by;
    in
    let move op by left right =
      left  := (op) !left  by;
      right := (op) !right by;
    in
      (* Assume that we will have to redraw. *)
      redraw := true;
      (* If a key was pressed, handle it. *)
      if event.keypressed then
        let handle_key = function
            'q' -> exit 0
          | '-' -> resolution := !resolution - 8
          | '+' -> resolution := !resolution + 8
          | 'i' -> zoom ( /. ) 1.1 from_x to_x from_y to_y
          | 'I' -> zoom ( /. ) 2.0 from_x to_x from_y to_y
          | 'o' -> zoom ( *. ) 1.1 from_x to_x from_y to_y
          | 'O' -> zoom ( *. ) 2.0 from_x to_x from_y to_y
          | 'h' -> move ( -. ) 0.1 from_x to_x
          | 'H' -> move ( -. ) 1.0 from_x to_x
          | 'j' -> move ( -. ) 0.1 from_y to_y
          | 'J' -> move ( -. ) 1.0 from_y to_y
          | 'k' -> move ( +. ) 0.1 from_y to_y
          | 'K' -> move ( +. ) 1.0 from_y to_y
          | 'l' -> move ( +. ) 0.1 from_x to_x
          | 'L' -> move ( +. ) 1.0 from_x to_x
          | c   -> redraw := false
        in
          handle_key event.key;
          
  done;;

(* mandeldraw.ml ends here. *)
