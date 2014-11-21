-module(gameoflife_test).
-include_lib("eunit/include/eunit.hrl").

-define(assertListEqual(L1, L2), ?assertEqual(lists:sort(L1), lists:sort(L2))).
-define(assertListContains(L1, E), ?assert(lists:any(fun(X) -> X =:= E end, L1))).
-define(assertListNotContains(L1, E), ?assert(lists:all(fun(X) -> X =/= E end, L1))).

empty_world_stays_empty_test() ->
    ?assertListEqual([], gameoflife:tick([])).

dies_if_underpopulated_test() ->
    ?assertListEqual([], gameoflife:tick([{1,1}])).

survives_if_two_neighbours_test() ->
    ?assertListEqual([{1,2},{1,1},{1,0}], gameoflife:tick([{0,1},{1,1},{2,1}])).

survives_if_three_neighbours_test() ->
    ?assertListContains(gameoflife:tick([{1,0}, {1,1}, {1,2}, {0,1}]), {1,1}).

dies_if_four_or_more_neighbours_test() ->
    [?assertListNotContains(gameoflife:tick([{1,0}, {1,1}, {1,2}, {0,1}, {2,1}]), {1,1}),
     ?assertListNotContains(gameoflife:tick([{1,0}, {1,1}, {1,2}, {0,1}, {2,1}, {2,2}]), {1,1})].
