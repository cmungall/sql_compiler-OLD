# Prolog index_util

Cache all results of calling a prolog goal

Example:

```
use_module(library(index_util)).

anc(A,B) :- isa(A,B).
anc(A,B) :- isa(A,Z),anc(Z,B).

ix :-
    materialize_index(anc(1,1)).

redundant_isa(A,B) :-
    isa(A,B),
    anc(A,Z),
    anc(Z,B).
```

When using this, optionally called `ix/0` first in order to enumerate all possible `anc/2` facts.

Indexes can also be persisted to disk

## Comparison with index/1

This module was created before swi-prolog introduced just-in-time indexing on all arguments, obviating the need for index/1.

However, index_utils is still useful for non-unit clauses (rules), where ground terms need to be recalculated each time

## Comparison with tabling

This module was created before swi-prolog introduced the tabling module. In many cases you will be better off with tabling.

In particular, note that index_util can only be used if the clause can be fully enumerated.

## Details

This is designed to be a swap-in replacement for index/1. Indexing a
fact with M arguments on N of those arguments will generate N sets of
facts with arguments reordered to take advantage of first-argument
indexing. The original fact will be rewritten.

For example, calling:

`materialize_index(my_fact(1,0,1)).`

will retract all `my_fact/3` facts and generate the following clauses in its place:

```
my_fact(A,B,C) :-
    nonvar(A),
    !,
    my_fact__ix_1(A,B,C).
my_fact(A,B,C) :-
    nonvar(C),
    !,
    my_fact__ix_3(C,A,B).
my_fact(A,B,C) :-
    my_fact__ix_1(A,N,C).
```

here `my_fact__ix_1` and `my_fact__ix_3` contain the same data as the original `my_fact/3` clause. In the second case, the arguments have been reordered
 
## Limitations

Single key indexing only. Could be extended for multikeys.
  
No automatic recalculation if underlying facts change. Should not be used on dynamic databases.

Does not have to be used with fact (unit clauses) - but the clauses should enumerable

