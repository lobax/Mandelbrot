-module(mandel).
-export([mandelbrot/7, demo/0]). 

demo() ->
    small(-2.6,1.2,1.6). 

small(X,Y,X1) ->
    Width = 960,
    Height = 540,
    K = (X1 -X)/Width, 
    Depth = 64,
    T0 = now(),
    mandelbrot(self(), Width, {Height div 2 + 1, Height}, X, Y, K,Depth),
    mandelbrot(self(), Width, {0, Height div 2}, X, Y, K,Depth),
    receive 
        {done, First } ->
            receive
                {done, Second} ->
                    Image = First ++ Second
            end
    end,
    T = timer:now_diff(now(), T0),
    io:format("picture generated in ~w ms~n", [T div 1000]),
    ppm:write("small.ppm", Image). 


mandelbrot(Pid, Width, {Start, Height}, X, Y, K, Depth) ->
    Trans = fun(W, H) ->
            cmplx:new(X + K*(W-1), Y-K*(H-1))
    end,
    spawn(fun() -> init(Pid, {Width, {Start, Height}, Trans, Depth, []}) end).



init(Pid, Settings) ->
    initThread(Pid, Settings).


initThread(Pid, {Width, Height, Trans, Depth, Acc}) ->
    Rows = rows(Width, Height, Trans, Depth, Acc),
    Pid ! {done, Rows},
    io:format("Dun", []).


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

