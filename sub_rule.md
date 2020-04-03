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

💡 We will write an algorithm for checking if there is any closed path and in case resolve it.


# Substitution tensor
The program should work with these steps:
  •1. Accept a tensor of substitions `T`.
  •2. Optimise the substitions' tensor.
  •3. Apply recursively the substitions.
The optimisation step should return a `T` such that a recursive substitions routine eventually stops.
## Form of the substition tensor
Defined an array of variables `α={α_1,α_2,...,α_N}` the elements of the substitutions tensor `T^m` must be `Union{T, PolyVar{C}, Monomial{C}, Term{C, T}}`.
Once decided how to deal with `Polynomial{C,T}` we should extend the substitions to the whole `MPolynomialLike`.
It must be even possible to specify each element of `T^m` as an `(m+1)-element Array{Int,1}`.
Each array will specify how to build the monomial to substitute.
  ***example***
  `T^2[1,2]=[1,3,4]` indicate the substitution `α_1α_2`→`α_3α_4`.
  `T^2[1,2]=[1,4,0]` indicate the substitution `α_1α_2`→`α_4`.
  `T^2[1,2]=[7,4,0]` indicate the substitution `α_1α_2`→`7*α_4`.
  `T^2[1,2]=[2,0,0]` indicate the substitution `α_1α_2`→`2`.
## Optimisation of the substitution tensor





🈺 This algorithm works for substitions of `MMonomialLike`→`MMonomialLike`.
   In the case one has to deal with substitions of `MMonomialLike`→`Polynomial` there are different possibilities.
   Suppose we are dealing with substitions tensor of order `m`. Let us consider `T^m[i_1,...,i_m]=P`, where `P` is a `Polynomial`.
   ✅All the monomial in `P` of order smaller then `m` are accepted.
   ❌All the monomial in `P` of order bigger then `m` are not accepted and we will not accept `T`.
   ✅If in `P` there is a single monomial of order `m` than one runs the algorithm for `MMonomialLike`→`MMonomialLike`following single monomials of order `m`.
   ❌If in `P` thare are more then one monomial of order `m` we will not accept the `T`.
   Possibly multiple monomial of degree `m` and monomial of degree higher then `m` are acceptable. We should ask Marc-Olivier.


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

<!-- 🚩Pay attention to the concept of _ordering_ for Pauli operators, as for example
  a normal ordered string of Pauli matrices would be `XYZ` but this string is
  equal to `I`.  -->


# Second physical example:
We consider the vector of Pauli operators `α={X_1,Y_1,Z_1,X_2,Y_2,Z_2}`.
The set of substitutions of degree `2` is the direct sum of the set of substitutions
of order `2` for `α_1={X_1,Y_1,Z_1}` `T^2_1` and the set of substitutions of order `2`
for  `α_2={X_2,Y_2,Z_2}` `T^2_2`. This _sparsity_ should be exploited for bigger systems.
