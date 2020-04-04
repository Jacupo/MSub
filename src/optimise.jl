function tuple_form(
                    vec::Array{PolyVar{C},1},
                    Tvar::Any) where {C}   #I am not sure how to write it
    N = size(vec,1);
    Ttu = [];
    for m=1:size(Tvar,1)
        T = Array{Tuple{Vararg{Int64,N} where N},m}(undef, ntuple(x->N, m));
        i1 = 0;
        for mon in Tvar[m]
            i1 += 1;
            #mon = _reduce(mon);
            vars = variables(mon);
            exps = exponents(mon);
            if isempty(vars) #This fails if the Tvar[m] is a matrix of Numbers
                T[i1]=(coefficient(mon),0);
            else
                arr = [coefficient(mon)];
                for v in zip(vars,exps)
                    append!(arr,fill(findfirst(x->x==v[1],vec),v[2]))
                end
                T[i1]=Tuple(Int(x) for x in arr);
            end
        end
        T = reshape(T, ntuple(x->N,m));
        append!(Ttu,[T]);
    end
    return Ttu;
end
