:- module(cases, [title/1, case/3]).
:- use_module('../prolog/renndiff').
:- use_module(engine).
title('renndiff').
neuron_g(n([A, B], C)) :- rnd_int(-3, 3, A), rnd_int(-3, 3, B), rnd_int(-4, 3, C).
net_g(N) :- ( rnd_chance(70) -> neuron_g(X), N = [[X]] ; neuron_g(X), neuron_g(Y), neuron_g(Z), N = [[X, Y], [Z]] ).
case(recover, [N], recover) :- net_g(N).
case(renndiff, [A, B], renndiff) :- net_g(A), ( rnd_chance(30), A = [[n([P, Q], R)]] -> maplist([X, Y]>>(Y is 2 * X), [P, Q, R], [P2, Q2, R2]), B = [[n([P2, Q2], R2)]] ; net_g(B) ).
case(truth_table, [N], truth_table) :- net_g(N).
