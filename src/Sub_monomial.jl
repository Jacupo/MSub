function Sub_monomial(mon1::Monomial{C}, 
                      mon2::PolyVar{C}, 
                      mon3::Union{PolyVar{C}, Monomial{C}, Number}) where {C}
    return Sub_monomial(mon1, Monomial{C}([mon2] ,[1]), mon3);
end

function Sub_monomial(mon1::Monomial{C}, 
                      mon2::Monomial{C}, 
                      mon3::Union{PolyVar{C}, Monomial{C}, Number}) where {C}

    mon1 = Unzero_monomial(mon1);
    mon2 = Unzero_monomial(mon2);
    p  = Find_monomial(mon1, mon2);
    
    if isempty(p)
        return mon1;
    end
    
    lp = length(p);
    l2 = length(mon2.z);

    if l2 == 1
        if p[1] != 1
            mon     = Monomial{C}(mon1.vars[1:(p[1]-1)], mon1.z[1:(p[1]-1)]);
        else
            mon = 1;
        end
        for i = 1:mon1.z[p[1]]
            mon     = *(mon, mon3);
        end
        for i=2:lp;
            tmon    = Monomial{C}(mon1.vars[(p[i-1]+l2):(p[i]-1)], mon1.z[(p[i-1]+l2):(p[i]-1)]);
            mon     = *(mon,tmon);
            for i=1:mon1.z[p[i]]
                mon     = *(mon, mon3)
            end
        end
        tmon    = Monomial{C}(mon1.vars[(p[end]+l2):end], mon1.z[(p[end]+l2):end]);
        mon     = *(mon,tmon);
    else
        if p[1]!=1
            mon     = Monomial{C}(mon1.vars[1:(p[1]-1)], mon1.z[1:(p[1]-1)]);
        else
            mon     = Monomial{C}([mon1.vars[1]], [mon1.z[1]-mon2.z[1]]);
            mon     = Unzero_monomial(mon);
        end
        mon     = *(mon,mon3);
        rmon    = Monomial{C}([mon1.vars[p[1]+l2-1]], [mon1.z[p[1]+l2-1]-mon2.z[l2]]);
        rmon    = Unzero_monomial(rmon);
        mon     = *(mon,rmon);
        for i=2:lp
            tmon    = Monomial{C}(mon1.vars[(p[i-1]+2):(p[i]-1)], mon1.z[(p[i-1]+2):(p[i]-1)]);
            mon     = *(mon,tmon);
            lmon    = Monomial{C}([mon1.vars[p[i]]], [mon1.z[p[i]]-mon2.z[1]]);
            lmon    = Unzero_monomial(lmon);
            mon     = *(mon,lmon);
            mon     = *(mon,mon3);
            rmon    = Monomial{C}([mon1.vars[p[i]+l2-1]], [mon1.z[p[i]+l2-1]-mon2.z[l2]]);
            rmon    = Unzero_monomial(rmon);
            mon     = *(mon,rmon);
        end
        tmon    = Monomial{C}(mon1.vars[(p[end]+2):end], mon1.z[(p[end]+2):end]);
        mon     = *(mon,tmon);
    end

    return mon; #Unzero mon?
end
