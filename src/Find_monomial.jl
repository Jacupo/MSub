"""
    findfirst(mon1::Monomial{C}, mon2::MMonomialLike{C})

Returns first position where mon2 can be found in the representation of mon1.
Second output is the length of mon2.
"""

function Base.findfirst(mon1::MMonomialLike{C}, mon2::PolyVar{C}) where {C}
        position = findfirst( x -> x == mon2, variables(mon1))
        if position isa Nothing
            return 0, 1
        else
            return position, 1
        end
end

function _subvectors(v::AbstractVector, l::Int)
    if l == 0
        return []
    else
        @assert length(v) >= l
        return [v[i:i+l-1] for i = 1:length(v)-l+1]
    end
end

function _match(c::Bool, v1::AbstractVector, v2::AbstractVector)
    if c || length(v2) <= 2
        return all(v1-v2.>=0)
    else
        v = v1-v2
        return first(v) >= 0 && last(v) >= 0 && all(v[2:end-1] .== 0)
    end
end

function Base.findfirst(mon1::Monomial{C}, mon2::Monomial{C}) where {C}
    position = 0
    exp1 = exponents(mon1)
    exp2 = exponents(mon2)
    l1 = length(exp1)
    l2 = length(exp2)
    if l1 >= l2
        candidates = findall(x -> x == variables(mon2), _subvectors(variables(mon1), l2))
        if !(candidates isa Nothing)
            idx = findfirst(c -> _match(C, exp1[c:c+l2-1], exp2), candidates)
            if !(idx isa Nothing)
                position = candidates[idx]
            end
        end
    end
    return position, l2
end

"""
    split(mon1::Monomial{C}, mon2::Monomial{C}) where {C}

Returns two monomials res1 and res2 such that mon1 = res1*mon2*res2.
Returns nothing if mon2 is not a factor of mon1.
"""
function split(mon1::Monomial{C}, mon2::MMonomialLike{C}) where {C}
    pos, l = findfirst(mon1, mon2)
    if pos == 0
        return nothing
    else
        exp1 = exponents(mon1)[1:pos-1]
        var1 = variables(mon1)[1:pos-1]
        exp2 = exponents(mon1)[pos+l-1:end]
        var2 = variables(mon1)[pos+l-1:end]
        # substract the exponent of the last variable in mon2 from the first on in res2
        exp2[1] -= last(exponents(mon2))

        if l > 1
            # if the exponent mon2 is longer than 1 we substract the remaining exponents from the tail of res1
            append!(exp1, exponents(mon1)[pos:pos+l-2] - exponents(mon2)[1:end-1])
            append!(var1, variables(mon1)[pos:pos+l-2])
        end
    end
    return Monomial{C}(var1, exp1), Monomial{C}(var2, exp2)
end
