# Idea:
We have a set of `N` variables `α={α_1,α_2,...,α_N}` minus the identity.
We define the set of substitutions of degree m with the tensor `T^m[i_1,i_2,...,i_m]` such that
`α_{i_1}*α_{i_2}*...α_{i_m}=T^m[i_1,i_2,...,i_m]`.
The number of elements of the tensor is `N^m`.
The general substitution will work by iterating over all indices of the tensor for all the specified degrees m  the `sub_monomial()` function

`sub_monomial(mon1,α_{i_1}*α_{i_2}*...α_{i_m},T^m_{i_1,i_2,...,i_m},recursive=true);`.

It has to be iterated until no possible substitutions are found.

**Deciding when to stop is critical**, we can easily fall in cyclical substitutions.
  ***example 1***
  We define
  •`α   = [x,y,z]`
  •`T^1 = [y,x,z]`
  •`mon1= x`
  then we have the following chain
  •_first iteration_ `x→y→x`
  •_second iteration_ `x→y→x`
  •...
  This is because there was a _closed path of substitutions_. **This must be avoided**.
  How can we avoid it? There is any theory for it?

💡If the degree of each element of `T^m[i_1,i_2,…,i_m]` is strictly smaller than `m` then we do not have closed  path of substitutions. This can be a first rudimentary check, but we are not considering all the possible substitutions, see next example.

  ***example 2***
  We define
  •`α   = [x,y,z]`
  •`T^1 = [y,_,_]`
  •`mon1= x`
  where `_` indicates that no substitutions are applied. Then we have the following chain
  •_first iteration_ `x→y`
  Here there are no closed path of substitutions in `T^1`.

❓There exist an algorithm for checking if there are closed paths and in case decide how to open them?



# First physical example:
We consider the vector of Pauli operators `α={X,Y,Z}`.
We indicate with `[A,B]` and `{A,B}` respectively the commutator and anticommutator of `A` and `B`.
The commutation and anticommutation rules of this set are known.
Given `[α_1,α_2]` and `{α_1,α_2}` we know that `α_1*α_2=([α_1,α_2]+{α_1,α_2})/2`.
The set of substitutions of degree `1` is
```
T^1=[_,_,_]
```
We can then build the set of substitutions of degree `2`:
```
        1   +iZ   -iY
T^2 = -iZ     1    iX
       iY   -iX     1
```
The degree of the elements of `T` is at most `1` thus there are no cyclic paths.
We can use it.


# Second physical example:
We consider the vector of Pauli operators `α={X_1,Y_1,Z_1,X_2,Y_2,Z_2}`.
The set of substitutions of degree `2` is the direct sum of the set of substitutions
of order `2` for `α_1={X_1,Y_1,Z_1}` `T^2_1` and the set of substitutions of order `2`
for  `α_2={X_2,Y_2,Z_2}` `T^2_2`. This sparsity should be exploited for bigger systems.
