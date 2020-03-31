module MSub

using MultivariatePolynomials;
using DynamicPolynomials;

const MMonomialLike{C} =  Union{PolyVar{C}, Monomial{C}}
# const MTermLike{C,T} = Union{MMonomialLike{C},Term{C,T}}
const MPolynomialLike{C, T} =  Union{T, PolyVar{C}, Monomial{C}, Term{C, T}, Polynomial{C, T}}

include("reduce.jl")
include("Find_monomial.jl");


# TODO remove when fixed, see https://github.com/JuliaAlgebra/DynamicPolynomials.jl/issues/58
function safe_multiplication(a::PolyVar{C}, b::Monomial{C}) where {C}
    return convert(Monomial{C}, a) * b
end

function safe_multiplication(a:: Monomial{C}, b::PolyVar{C}) where {C}
    return a * convert(Monomial{C}, b)
end

function safe_multiplication(a::Monomial{C}, b::Monomial{C}) where {C}
    return a * b
end

include("Sub_monomial.jl");

#=
function sub_monomial(
              poly1::Polynomial{C, T},
              mon2::MMonomialLike{C},
              mon3::MPolynomialLike{C, T}) where {C,T}
    poly = 0;
    for (c, m) in zip(coefficients(poly1), monomials(poly1))
        poly    += c*sub_monomial(Monomial{C}(variables(poly1), exponents(m)), mon2, mon3);
    end

    return poly;
end
=#
export sub_monomial;
end
