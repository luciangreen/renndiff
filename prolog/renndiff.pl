% renndiff: compare two trained nets by recovering readable code from each and diffing the code.
% A net (integer weights, step activation) on two boolean inputs is recovered as its truth table
% and then named (and, or, xor, ...) or written as a sum of minterms. Two nets that look
% different in their weights can recover the same code; renndiff says same, or lists the inputs
% where they differ and what each gives.
%?- recover([[n([2,2],-3)]], C).                                   % C = and
%?- renndiff([[n([1,1],-1)]], [[n([5,5],-9)]], D).                % D = same(and)
%?- renndiff([[n([1,1],0)]], [[n([1,1],-1)]], D).                 % D = differ(or, and, [[0,1]-(1-0), [1,0]-(1-0)])
:- module(renndiff, [neuron/3, forward/3, truth_table/2, recover/2, renndiff/3, code_of/2]).
:- use_module(library(lists)).
:- use_module(library(apply)).

neuron(n(Ws, B), Xs, Y) :- foldl([W, X, A0, A]>>(A is A0 + W * X), Ws, Xs, B, S), ( S > 0 -> Y = 1 ; Y = 0 ).
forward([], Xs, Xs).
forward([L|Ls], Xs, Out) :- maplist([N, Y]>>neuron(N, Xs, Y), L, Ys), forward(Ls, Ys, Out).

inputs([[0,0], [0,1], [1,0], [1,1]]).
truth_table(Net, T) :- inputs(Is), maplist([I, Y]>>forward(Net, I, [Y]), Is, T).

% Names for the 16 two-input functions (outputs on 00, 01, 10, 11).
name([0,0,0,0], false). name([1,1,1,1], true).
name([0,0,0,1], and).   name([0,1,1,1], or).    name([0,1,1,0], xor).
name([1,1,1,0], nand).  name([1,0,0,0], nor).   name([1,0,0,1], xnor).
name([0,0,1,1], a).     name([0,1,0,1], b).     name([1,1,0,0], not_a).  name([1,0,1,0], not_b).
name([0,0,1,0], a_and_not_b). name([0,1,0,0], b_and_not_a). name([1,0,1,1], b_implies_a). name([1,1,0,1], a_implies_b).

% code_of(+Table, -Code): the name, which is also readable code.
code_of(T, C) :- name(T, C).
recover(Net, C) :- truth_table(Net, T), code_of(T, C).

renndiff(N1, N2, D) :- truth_table(N1, T1), truth_table(N2, T2), code_of(T1, C1), code_of(T2, C2),
    ( T1 == T2 -> D = same(C1) ; inputs(Is), findall(I-(Y1-Y2), ( nth0(K, Is, I), nth0(K, T1, Y1), nth0(K, T2, Y2), Y1 =\= Y2 ), Ds), D = differ(C1, C2, Ds) ).
