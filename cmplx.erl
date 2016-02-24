-module(cmplx). 
-export([new/2,add/2,sqr/1,abs/1]). 

new(X, Y) ->
    {X, Y}. 

add({Ar, Ai}, {Br, Bi}) ->
    {Ar + Br, Ai + Bi}. 

sqr({R, I}) ->
    {R*R - I*I, 2*R*I}. 

abs({R,I}) ->
    math:sqrt(I*I + R*R). 

