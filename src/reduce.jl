"""
    _reduce(p::PolyVar)
    _reduce(p::Monomial)

Returns a monomial equivalent to p but without zeros in the exponent vector.
"""
function _reduce(p::PolyVar{C}) where C
    return convert(Monomial{C}, p)
end

function _reduce(p::Monomial{C}) where C
    f = findall(!iszero, exponents(p))
    if isempty(f)
        return one(Monomial{C})
    else
        return Monomial{C}(variables(p)[f], exponents(p)[f])
    end
end
