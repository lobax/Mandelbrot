-module(mandel).
-export([mandelbrot/6, demo/0]). 

demo() ->
    small(-2.6,1.2,1.6). 

small(X,Y,X1) ->
    Width = 960,
    Height = 540,
    K = (X1 -X)/Width, 
    Depth = 64,
    T0 = now(),
    Image1 = mandelbrot(Width, {Height div 2 + 1, Height}, X, Y, K,Depth),
    Image1 = mandelbrot(Width, {0, Height div 2}, X, Y, K,Depth),
    T = timer:now_diff(now(), T0),
    io:format("picture generated in ~w ms~n", [T div 1000]),
    ppm:write("small.ppm", Image). 


mandelbrot(Width, {Start, Height}, X, Y, K, Depth) ->
    Trans = fun(W, H) ->
            cmplx:new(X + K*(W-1), Y-K*(H-1))
    end,
    spawn(fun() -> init(self(), {Width, {Height div 2, Height}, Trans, Depth, []}) end),
    io:format("Dun", []),
    receive
        Rows ->
            io:format("Checkpoint", [])
    end,
    Rows.

init(Pid, Settings) ->
    initThread(Pid, Settings).


initThread(Pid, {Width, Height, Trans, Depth, Acc}) ->
    Pid ! rows(Width, Height, Trans, Depth, Acc),
    io:format("Rows Done", []),
    ok.


rows(_,{End, Height},_,_,Acc) when End == Height ->
    Acc;

rows(Width, {End, Height}, Trans, Depth, Acc) ->
    Col = column(Width, Height, Trans, Depth, []), 
    rows(Width, {End, Height-1}, Trans, Depth, [Col|Acc]).

column(0, _, _, _, Acc) ->
    Acc;

column(Width, Height, Trans, Depth, Acc) ->
    C = Trans(Width, Height),
    D = brot:mandelbrot(C, Depth), 
    RGB = color:convert(D,Depth),
    column(Width-1, Height, Trans, Depth, [RGB|Acc]). 

