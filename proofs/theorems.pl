% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/renndiff').

% Domain: every single-neuron net with weights and bias in -2..2, and the two-layer nets made from pairs of them.
neuron1(n([A, B], C)) :- between(-2, 2, A), between(-2, 2, B), between(-2, 2, C).
net1([[N]]) :- neuron1(N).

% 1. Every truth table has exactly one name: recovery always gives code.
theorem(every_function_named) :- forall(( between(0, 15, X), maplist([I, B]>>(B is (X >> I) /\ 1), [0, 1, 2, 3], T) ), findall(C, code_of(T, C), [_])).

% 2. same exactly when the nets compute the same function, whatever their weights.
theorem(same_iff_same_function) :- forall(( net1(A), net1(B) ), ( renndiff(A, B, D), truth_table(A, T1), truth_table(B, T2), iff(D = same(_), T1 == T2) )).

% 3. The differences listed are exactly the inputs where the outputs differ.
theorem(differences_exact) :- forall(( net1(A), net1(B), renndiff(A, B, differ(_, _, Ds)) ), ( inputs(Is), forall(member(I, Is), ( forward(A, I, [Y1]), forward(B, I, [Y2]), iff(memberchk(I-_, Ds), Y1 =\= Y2) )) )).

% 4. Scaling a neuron's weights and bias by a positive number recovers the same code.
theorem(scaling_keeps_code) :- forall(( neuron1(n([A, B], C)), member(K, [2, 3]) ), ( A2 is K * A, B2 is K * B, C2 is K * C, recover([[n([A, B], C)]], X), recover([[n([A2, B2], C2)]], X) )).

% 5. The xor net (two layers) recovers xor.
theorem(two_layer_xor) :- recover([[n([1, 1], 0), n([-1, -1], 2)], [n([1, 1], -1)]], xor).
