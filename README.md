# renndiff

compare two trained nets by recovering readable code from each and diffing the code. A net (integer weights, step activation) on two boolean inputs is recovered as its truth table and then named (and, or, xor, ...) or written as a sum of minterms. Two nets that look different in their weights can recover the same code; renndiff says same, or lists the inputs where they differ and what each gives.

## Use

```prolog
?- use_module(prolog/renndiff).
?- recover([[n([2,2],-3)]], C).                                   % C = and
?- renndiff([[n([1,1],-1)]], [[n([5,5],-9)]], D).                % D = same(and)
?- renndiff([[n([1,1],0)]], [[n([1,1],-1)]], D).                 % D = differ(or, and, [[0,1]-(1-0), [1,0]-(1-0)])
```

## Proofs

`proofs/theorems.pl` proves 5 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every single-neuron net with weights and bias in -2..2, and the two-layer nets made from pairs of them.

1. Every truth table has exactly one name: recovery always gives code.
2. same exactly when the nets compute the same function, whatever their weights.
3. The differences listed are exactly the inputs where the outputs differ.
4. Scaling a neuron's weights and bias by a positive number recovers the same code.
5. The xor net (two layers) recovers xor.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
