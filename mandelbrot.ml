(* mandelbrot.ml --- Calculate Mandelbrot set.
 * Copyright 2003 by Dave Pearson <davep@davep.org>
 * $Revision: 1.2 $
 * 
 * mandelbrot.ml is free software distributed under the terms of the GNU
 * General Public Licence, version 2. For details see the file COPYING.
 *
 * Commentary:
 * 
 * The following code is my first play with OCaml, it calculates a
 * Mandelbrot set.
 *
 *)

(* We're going to be using complex numbers. *)
open Complex;;

(* The main function *)
let mandelbrot min_x max_x min_y max_y width height resolution inside outside each_x each_y =
  for x = 0 to width do
    each_x x;
    for y = 0 to height do
      each_y y;
      let rec do_point point c i =
        if ( norm point ) > 2. then
          outside x y i point resolution
        else if i = 0 then
          inside x y i point resolution
        else
          do_point (add c (mul point point)) c ( i - 1 ) in
      let calc_point min max n dim = min +. ( ( max -. min ) *. ( float_of_int n /. float_of_int dim ) ) in
        do_point
          { re = 0.0; im = 0.0 }
          { re = calc_point min_x max_x x width; im = calc_point min_y max_y y height }
          resolution
    done
  done;;

(* mandelbrot.ml ends here. *)
