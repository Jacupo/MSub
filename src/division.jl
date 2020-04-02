function find_degree(mon1::MMonomialLike{true}, mon2::MMonomialLike{true})
    deg = maximum(exponents(mon1));
    for m in zip(variables(mon2),exponents(mon2))
        position = findfirst(mon1,Monomial{true}([m[1]],[m[2]]))[1];
        if position==0
            return 0;
        end
        deg = min(deg,floor(exponents(mon1)[position]/m[2]));
    end
    return convert(Int,deg);
end



# function division(mon1::MMonomialLike{true},mon2::MMonomialLike{true},deg::Int)
#     for m in zip(variables(mon2),exponents(mon2))
#         subs(mon1,m[1]=>1);
#         position = findfirst(mon1,Monomial{true}([m[1]],[m[2]]))[1];
#         new_exponent = exponents(mon1)[position] - deg*m[2];
#         div = m[1]^new_exponent;
#     end
#     return div;
# end
