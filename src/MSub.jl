module MSub
using MultivariatePolynomials
using DynamicPolynomials;

function Unzero_monomial(mon::Monomial{C}) where {C}
    f = findall(x->x!=0, exponents(mon));
    if isempty(f)
        return 1;
    end
    z       = zeros(Int, length(f));
    var     = PolyVar{C}[];
    i       = 0;
    for p in f
        i += 1;
        z[i]    = exponents(mon)[p];
        push!(var, variables(mon)[p]);
    end

    return Monomial(var, z);
end

include("Find_monomial.jl");
include("Sub_monomial.jl");

function Sub2(
              poly1::Polynomial{C,T}, 
              mon2::Union{PolyVar{C}, Monomial{C}}, 
              mon3::Union{PolyVar{C}, Monomial{C}}) where {C,T}
    poly = 0;
    for (c, m) in zip(coefficients(poly1), monomials(poly1))
        poly    += c*Sub_monomial(Monomial{C}(variables(poly1), exponents(m)), mon2, mon3);
    end

    return poly;
end

export Sub2, Sub_monomial;
end
