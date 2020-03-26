function Find_monomial(mon1::Monomial{C}, mon2::PolyVar{C}) where {C}
    return Find_monomial(mon1, Monomial{C}([mon2], [1]));
end
function Find_monomial(mon1::Monomial{C}, mon2::Monomial{C}) where {C}
    #Is it impossible for mon2 to intersecate? i.e. position == 1,2 and l2 == 2.
    l1 = length(mon1.z);
    l2 = length(mon2.z);
    positions = [];
    if l2 > l1
        return positions;
    end
    if l2>2
        for i=1:(1+l1-l2)
            if (mon1.vars[i:(i+l2-1)]==mon2.vars && mon1.z[(i+1):(l2+i-2)]==mon2.z[2:(end-1)]&& mon1.z[i]>=mon2.z[1] && mon1.z[i+l2-1]>=mon2.z[l2])
                push!(positions,i);
            end
        end
    else
        for i=1:(1+l1-l2)
            if (mon1.vars[i:(i+l2-1)]==mon2.vars && mon1.z[i]>=mon2.z[1] && mon1.z[i+l2-1]>=mon2.z[l2])
                push!(positions,i);
            end
        end
    end

    return positions;
end
