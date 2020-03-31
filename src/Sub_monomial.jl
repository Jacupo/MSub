function sub_monomial(
                      mon1::Number,
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}) where {C,T}
    return mon1
end

function sub_monomial(
                      mon1::PolyVar{C},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}) where {C,T}
    if mon1 == mon2
        return mon3
    else
        return mon1
    end
end

function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::T) where {C, T <: Number}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    reduced = false
    coef = one(T)
    while !reduced
        factors = split(mon1, mon2)
        if factors isa Nothing
            reduced = true
        else
            mon1 = _reduce(safe_multiplication(first(factors), last(factors)))
            coef *= mon3
        end
    end
    return coef*mon1
end

# function sub_monomial(
#                       mon1::Monomial{C},
#                       mon2::MMonomialLike{C},
#                       mon3:: MMonomialLike{C}) where {C}
#     mon1 = _reduce(mon1)
#     mon2 = _reduce(mon2)
#     reduced = false
#     factors = split(mon1, mon2)
#     if factors isa Nothing
#         reduced = return mon1;
#     else
#         mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), mon3), sub_monomial(last(factors), mon2, mon3)))
#     end
#     return mon1
# end

function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::MTermLike{C, T}) where {C, T}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    factors = split(mon1, mon2)
    if factors isa Nothing
        return mon1;
    else
        term = sub_monomial(last(factors),mon2,mon3);
        mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), monomial(mon3)), monomial(term)))
    end

    return coefficient(term)*coefficient(mon3)*mon1;
end

function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::Polynomial{C, T}) where {C, T}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    factors = split(mon1, mon2)
    if factors isa Nothing
        return mon1
    else
        return sum(sub_monomial( coefficient(t)*safe_multiplication(safe_multiplication(first(factors), monomial(t)), last(factors)), mon2, mon3) for t in DynamicPolynomials.TermIterator(mon3))
    end
end


function sub_monomial(
                      mon1::Term{C,T},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}) where {C, T}
    return coefficient(mon1)*sub_monomial(monomial(mon1), mon2, mon3)
end


function sub_monomial(
                      mon1::Polynomial{C,T},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}) where {C, T}
    return sum(sub_monomial(t, mon2, mon3) for t in DynamicPolynomials.TermIterator(mon1))
end



#=
function sub_monomial(
                        mon1::MTermLike{C,T},
                        mon2::PolyVar{C},
                        mon3::MTermPoly{C,T}) where {C,T}
    return sub_monomial(mon1, Monomial{C}([mon2],[1]), mon3);
end
function sub_monomial(
                        mon1::Term{C,T},
                        mon2::Monomial{C},
                        mon3::MTermPoly{C,T}) where {C,T}
    return coefficient(mon1)*sub_monomial(monomial(mon1), mon2, mon3);
end

function sub_monomial(
                        mon1::Monomial{C},
                        mon2::Monomial{C},
                        mon3::MTermPoly{C,T}) where {C,T}
    mon1 = _reduce(mon1);
    mon2 = _reduce(mon2);
    p  = find_monomial(mon1, mon2);
    lp = length(p);
    l2 = length(exponents(mon2));

    if isempty(p)
        return mon1;
    end

    if l2==1
        # subs(mon1, variables(mon2)[1] => mon3); #Do not work with (x * y * z * x * z * y * z * x ^ 3, x, a * b) and others
        if p[1]!=1
            mon     = Monomial{C}(variables(mon1)[1:(p[1]-1)], exponents(mon1)[1:(p[1]-1)]);
        else
            mon=1;
        end
        for i=1:exponents(mon1)[p[1]]
            mon     = *(mon,mon3);
        end
        for i=2:lp;
            tmon    = Monomial{C}(variables(mon1)[(p[i-1]+l2):(p[i]-1)], exponents(mon1)[(p[i-1]+l2):(p[i]-1)]);
            mon     = *(mon,tmon);
            for i=1:exponents(mon1)[p[i]]
                mon     = *(mon,mon3)
            end
        end
        tmon    = Monomial{C}(variables(mon1)[(p[end]+l2):end], exponents(mon1)[(p[end]+l2):end]);
        mon     = *(mon,tmon);
    else
        if p[1]!=1
            mon     = Monomial{C}(variables(mon1)[1:(p[1]-1)], exponents(mon1)[1:(p[1]-1)]);
        else
            mon     = Monomial{C}([variables(mon1)[1]], [exponents(mon1)[1]-mon2.z[1]]);
            mon     = unzero(mon);
        end
        mon     = *(mon,mon3);
        rmon    = Monomial{C}([variables(mon1)[p[1]+l2-1]], [exponents(mon1)[p[1]+l2-1]-mon2.z[l2]]);
        rmon    = unzero(rmon);
        mon     = *(mon,rmon);
        for i=2:lp
            tmon    = Monomial{C}(variables(mon1)[(p[i-1]+2):(p[i]-1)], exponents(mon1)[(p[i-1]+2):(p[i]-1)]);
            mon     = *(mon,tmon);
            lmon    = Monomial{C}([variables(mon1)[p[i]]], [exponents(mon1)[p[i]]-mon2.z[1]]);
            lmon    = unzero(lmon);
            mon     = *(mon,lmon);
            mon     = *(mon,mon3);
            rmon    = Monomial{C}([variables(mon1)[p[i]+l2-1]], [exponents(mon1)[p[i]+l2-1]-mon2.z[l2]]);
            rmon    = unzero(rmon);
            mon     = *(mon,rmon);
        end
        tmon    = Monomial{C}(variables(mon1)[(p[end]+2):end], exponents(mon1)[(p[end]+2):end]);
        mon     = *(mon,tmon);
    end

    return mon; #Unzero mon?
end
=#
