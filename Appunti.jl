using DynamicPolynomials
using Revise
using MSub

@polyvar q w e r

sub_monomial(q^2*r^2, q*r,e)
MSub.find_degree(q^2*r^2, q*r)
sub_monomial(q^6*r^2,q^2*r,e)
mon2 = q*r^2
for m in zip(variables(mon2),exponents(mon2))
    println(m[1], ", ", m[2])
    println(typeof(m[1]), ", ", typeof(m[2]))
end

mon2^2

sub_monomial(q^6*r^2,q^2,1)
