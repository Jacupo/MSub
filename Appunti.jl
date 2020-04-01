using DynamicPolynomials
# using Revise
using MSub

@polyvar q w e r

sub_monomial(q^2*r^2, q*r,e, recursive=true)

q^2*r^2 isa MSub.MPolynomialLike{true}
q*r isa MSub.MMonomialLike{true}
e isa MSub.MPolynomialLike{true}
