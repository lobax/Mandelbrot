-module(brot).
-export([mandelbrot/2]). 

mandelbrot(C, M) ->
    Z0 = cmplx:new(0,0),
    I = 0,
    test(I, Z0, C, M). 


test(_, _, _, 0) ->
    0; 

test(I, Z, C, M) ->
    case Abs = cmplx:abs(Z) of 
        Abs when Abs >= 2 ->
            I;
        _ ->
            test(I+1, cmplx:add(cmplx:sqr(Z), C), C, M -1)
    end.
        
