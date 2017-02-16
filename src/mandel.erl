-module(mandel).
-export([mandelbrot/6, demo/0]). 

demo() ->
    small(-2.6,1.2,1.6), 
    init:stop(). 

small(X,Y,X1) ->
    Width = 960,
    Height = 540,
    K = (X1 -X)/Width, 
    Depth = 64,
    T0 = now(),
    Image = mandelbrot(Width, Height, X, Y, K,Depth),
    T = timer:now_diff(now(), T0),
    io:format("picture generated in ~w ms~n", [T div 1000]),
    ppm:write("small.ppm", Image). 


mandelbrot(Width, Height, X, Y, K, Depth) ->
    Trans = fun(W, H) ->
            cmplx:new(X + K*(W-1), Y-K*(H-1))
    end,
    rows(Width, Height, Trans, Depth, []). 

rows(_,0,_,_,Acc) ->
    Acc;

rows(Width, Height, Trans, Depth, Acc) ->
    Col = column(Width, Height, Trans, Depth, []), 
    rows(Width, Height-1, Trans, Depth, [Col|Acc]).

column(0, _, _, _, Acc) ->
    Acc;

column(Width, Height, Trans, Depth, Acc) ->
    C = Trans(Width, Height),
    D = brot:mandelbrot(C, Depth), 
    RGB = color:convert(D,Depth),
    column(Width-1, Height, Trans, Depth, [RGB|Acc]). 

