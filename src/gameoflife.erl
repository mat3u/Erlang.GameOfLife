-module(gameoflife).

-export([tick/1, ticks/2, render/1]).

ticks(World, 0) -> World;
ticks(World, N) ->
    ticks(tick(World), N -1).

tick([]) ->
    [];
tick(World) ->
    Neighbourhood = lists:flatmap(fun neighbourhood/1, World),
    PossibleCells = sets:to_list(sets:from_list(Neighbourhood ++ World)),

    lists:filter(fun(X) -> X =/= {} end,
                 lists:map(fun(C) -> 
                                   N = length(lists:filter(fun(X) -> X =:= C end, Neighbourhood)),
                                   L = lists:any(fun(X) -> X =:= C end, World),

                                   case {L, N} of
                                       {true, 2} -> C;
                                       {_, 3} -> C;
                                       _ -> {}
                                   end
                           end,
                           PossibleCells)).

neighbourhood({X,Y}) ->
    [{X-Xd, Y-Yd} || Xd <- [-1,0,1], Yd <- [-1,0,1]] -- [{X,Y}].

render(World) ->
    MinW = lists:min(lists:map(fun({X,_}) -> X end, World)),
    MinH = lists:min(lists:map(fun({_,Y}) -> Y end, World)),
    Width = lists:max(lists:map(fun({X,_}) -> X - MinW end, World)),
    Height = lists:max(lists:map(fun({_, Y}) -> Y - MinH end, World)),

    render_world({Width + 1, Height}, {0, 0}, World),

    io:format(<<"~n">>).

render_world(Dim, Dim, _) -> ok;
render_world({W, H}, {W, CurrentH}, World) -> 
    io:format(<<"~n">>),
    render_world({W, H}, {0, CurrentH + 1}, World);
render_world(Dim, {CurrentW, CurrentH}, World) ->
    IsAlive = lists:any(fun(X) -> X =:= {CurrentW, CurrentH} end, World),
    case IsAlive of
        true -> io:format(<<"x">>);
        _ -> io:format(<<".">>)
    end,
    render_world(Dim, {CurrentW + 1, CurrentH}, World).

