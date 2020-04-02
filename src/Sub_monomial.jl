function sub_monomial(
                      mon1::Number,
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}; recursive=true) where {C,T}
    return mon1
end

function sub_monomial(
                      mon1::PolyVar{C},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}; recursive=true) where {C,T}
    if mon1 == mon2
        return mon3
    else
        return mon1
    end
end

function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::T; recursive=false) where {C, T <: Number}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    if C && size(variables(mon2),1)>1
        deg = find_degree(mon1,mon2);
        if deg==0
            return mon1;
        else
            mon1 = div(mon1,mon2);
        end
        return mon1*mon3^deg;
    else
        if recursive
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
        else
            return sub_monomial(mon1,mon2,mon3*one(Monomial{C}));
        end
    end


end


function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::MMonomialLike{C}; recursive=false) where {C, T}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    if C && size(variables(mon2),1)>1
        deg = find_degree(mon1,mon2);
        if deg==0
            return mon1;
        else
            mon1 = div(mon1,mon2);
        end
        return mon1*mon3^deg;
    else
        if recursive
            reduced =false
            while !reduced
                factors = split(mon1, mon2)
                if factors isa Nothing
                    reduced = true
                else
                    mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), mon3), last(factors)))
                end
            end
        else
            factors = split(mon1, mon2)
            if factors isa Nothing
                return mon1;
            else
                term = sub_monomial(last(factors),mon2,mon3);
                mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), mon3), term))
            end
        end
    end
    return mon1;
end


function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::Term{C,T};recursive=false) where {C, T}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    if C && size(variables(mon2),1)>1
        deg = find_degree(mon1,mon2);
        if deg==0
            return mon1;
        else
            mon1 = div(mon1,mon2);
        end
        return mon1*mon3^deg;
    else
        if recursive
            coef = one(T)
            reduced =false
            while !reduced
                factors = split(mon1, mon2)
                if factors isa Nothing
                    reduced = true
                else
                    mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), monomial(mon3)), last(factors)))
                    coef *= coefficient(mon3)
                end
            end
            return coef*mon1
        else
            factors = split(mon1, mon2)
            if factors isa Nothing
                return mon1;
            else
                term = sub_monomial(last(factors),mon2,mon3);
                mon1 = _reduce(safe_multiplication(safe_multiplication(first(factors), monomial(mon3)), monomial(term)))
            end
            return coefficient(term)*coefficient(mon3)*mon1;
        end
    end
end

function sub_monomial(
                      mon1::Monomial{C},
                      mon2::MMonomialLike{C},
                      mon3::Polynomial{C, T}; recursive=false) where {C, T}
    mon1 = _reduce(mon1)
    mon2 = _reduce(mon2)
    if C && size(variables(mon2),1)>1
        deg = find_degree(mon1,mon2);
        if deg==0
            return mon1;
        else
            mon1 = div(mon1,mon2);
        end
        return mon1*mon3^deg;
    else
        factors = split(mon1, mon2)
        if factors isa Nothing
            return mon1
        else
            return sum(sub_monomial( coefficient(t)*safe_multiplication(safe_multiplication(first(factors), monomial(t)), last(factors)), mon2, mon3, recursive=recursive) for t in DynamicPolynomials.TermIterator(mon3))
        end
    end
end


function sub_monomial(
                      mon1::Term{C,T},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}; recursive=false) where {C, T}
    return coefficient(mon1)*sub_monomial(monomial(mon1), mon2, mon3, recursive=recursive)
end


function sub_monomial(
                      mon1::Polynomial{C,T},
                      mon2::MMonomialLike{C},
                      mon3::MPolynomialLike{C, T}; recursive=false) where {C, T}
    return sum(sub_monomial(t, mon2, mon3, recursive=recursive) for t in DynamicPolynomials.TermIterator(mon1))
end
