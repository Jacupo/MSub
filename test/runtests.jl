using DynamicPolynomials
using Test
using MSub

@ncpolyvar x y z a b c


@testset "findfirst" begin
    @testset "Find PolyVar" begin
        @test findfirst(x*y*z*x*z*y*x, x)== (1, 1);
        @test findfirst(x*y*x^2*z, x) == (1, 1);
    end
    @testset "Find Monomial(1)" begin
        @test findfirst(x*y*z*x*z*y*x, Monomial{false}([x],[1])) == (1, 1);
    end
    @testset "Find Monomial(>1)" begin
        @test findfirst(x*y^3*z^2*x^2, y*z*x) == (0, 3);
        @test findfirst(x*y*z*x*z^2*x*y, x*y) == (1, 2);
        @test findfirst(x^3*y^2*z, x*y) == (1, 2);
        @test findfirst(x*y*z*x*z^2*x*y^2, x*y^2) == (6, 2);
        @test findfirst(x*y*z*y*z^2*y, x*y*z) == (1, 3);
        @test findfirst(x*y*z^2*y*z^2*y, x*y*z) == (1, 3);
        @test findfirst(x*y*z^2*y*z^2*y*x*y*z, x*y*z)==(1, 3);
        @test findfirst(x*y*z*y*z^2*y*x*y*z^3, x*y*z^2) == (7, 3);
    end
end

@testset "Non-Commutative sub_monomial" begin
    @testset "sub_monomial recursive=FALSE" begin
        @testset "number,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(4,x*y,3)==4;
        end
        @testset "Polyvar,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(x,a,2)==x;
            @test sub_monomial(x,x,2)==2;
            @test sub_monomial(x,x,y)==y;
        end
        @testset "Monomial,MMonomialLike,Number" begin
            @test sub_monomial(x*z*y,a,3)==x*z*y;
            @test sub_monomial(x*z*x,z,3)==3*x^2;
            @test sub_monomial(x*y,x*y,3)==3;
            @test sub_monomial(x^2*z^3,x*z,3)==3*x*z^2;
        end
        @testset "Monomial,MMonomialLike,MMonomialLike" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,x,a*b)==a*b*y*z*a*b*a*b*z*y*z*a*b;
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,a*b)==x*y*a*b*x*z*y*a*b;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,a*b)==x^2*a*b*y*z*x^2*z;
            @test sub_monomial(z*x*y*z,x*y,x^2*y^2)==z*x^2*y^2*z;
        end
        @testset "Monomial,MMonomialLike,Term" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b)==9*x*y*a*b*x*z*y*a*b;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b)==3*x^2*a*b*y*z*x^2*z;
            @test sub_monomial(x^2*y^2,x*y,-y*x) == -x*y*x*y;
        end
        @testset "Monomial,MMonomialLike,Polynomial" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b+1)==9*x*y*a*b*x*z*y*a*b+3*x*y*a*b*x*z*y+3*x*y*x*z*y*a*b+x*y*x*z*y;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+1)==3*x^2*a*b*y*z*x^2*z+3*x*a*b*z*x^2*z+x*z*x^2*z;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+c)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z;
        end
        @testset "Term,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x,a)==13*a*y*z*a*z*y*z*a;
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,a*b)==13*a*b*z*x*z*y*z*x;
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,a*b)==17*x^2*a*b*z*x^2*z;
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b)==39*a*b*z*x*z*y*z*x;
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b)==51*x^2*a*b*z*x^2*z;
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b+1)==39*a*b*z*x*z*y*z*x+13*z*x*z*y*z*x;
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b+1)==51*x^2*a*b*z*x^2*z+17*x^2*z*x^2*z;
        end
        @testset "Term,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(x^3*y^2*z*x^2*z+5*a*x*y*c,x*y,3*a*b)==3*x^2*a*b*y*z*x^2*z+15*a^2*b*c;
            @test sub_monomial(x^3*y^2*z*x^2*z+x*y*c,x*y,3*a*b+c)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z+3*a*b*c+c^2;
        end
    end


    @testset "sub_monomial recursive=TRUE" begin
        @testset "Monomial,MMonomialLike,Number" begin
            @test sub_monomial(x*z*y,a,3,recursive=true)==x*z*y;
            @test sub_monomial(x*z*x,z,3,recursive=true)==3*x^2;
            @test sub_monomial(x*y,x*y,3,recursive=true)==3;
            @test sub_monomial(x^2*z^3,x*z,3,recursive=true)==9*z;#DIFFERENT from recursive=false
        end
        @testset "Monomial,MMonomialLike,MMonomialLike" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,x,a*b,recursive=true)==a*b*y*z*a*b*a*b*z*y*z*a*b;
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,a*b,recursive=true)==x*y*a*b*x*z*y*a*b;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,a*b,recursive=true)==x^2*a*b*y*z*x^2*z;
            #@test sub_monomial(z*x*y*z,x*y,x^2*y^2,recursive=true)==z*x^2*y^2*z; #It explodes 爆発
            @test sub_monomial(x^2*z^3,x*z,a,recursive=true)==x*a*z^2; #DIFFERENT from recursive=false
        end
        @testset "Monomial,MMonomialLike,Term" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b,recursive=true)==9*x*y*a*b*x*z*y*a*b;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b,recursive=true)==3*x^2*a*b*y*z*x^2*z;
            @test sub_monomial(x^2*y^2,x*y,-y*x,recursive=true) == y^2*x^2; #DIFFERENT from recursive=false
        end
        @testset "Monomial,MMonomialLike,Polynomial" begin
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b+1,recursive=true)==9*x*y*a*b*x*z*y*a*b+3*x*y*a*b*x*z*y+3*x*y*x*z*y*a*b+x*y*x*z*y;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+1,recursive=true)==3*x^2*a*b*y*z*x^2*z+3*x*a*b*z*x^2*z+x*z*x^2*z;
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+c,recursive=true)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z;
        end
        @testset "Term,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x,a,recursive=true)==13*a*y*z*a*z*y*z*a;
            @test sub_monomial(13*x*y*x*y*x*y*x*y,x*y,y*x,recursive=true)==13*y^4*x^4;     #DIFFERENT from recursive=false
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,a*b,recursive=true)==17*x^2*a*b*z*x^2*z;
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b,recursive=true)==39*a*b*z*x*z*y*z*x;
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b,recursive=true)==51*x^2*a*b*z*x^2*z;
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b+1,recursive=true)==39*a*b*z*x*z*y*z*x+13*z*x*z*y*z*x;
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b+1,recursive=true)==51*x^2*a*b*z*x^2*z+17*x^2*z*x^2*z;
        end
        @testset "Term,MMonomialLike,MPolynomialLike" begin
            @test sub_monomial(x^3*y^2*z*x^2*z+5*a*x*y*c,x*y,3*a*b,recursive=true)==3*x^2*a*b*y*z*x^2*z+15*a^2*b*c;
            @test sub_monomial(13*x*y*x*y*x*y*x*y+x*x*y*y,x*y,y*x,recursive=true)==13*y^4*x^4+y^2*x^2;
            @test sub_monomial(x^3*y^2*z*x^2*z+x*y*c,x*y,3*a*b+c,recursive=true)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z+3*a*b*c+c^2;
            @test sub_monomial(x^3*y^2*z*x^2*z+x*y*c,x*y,-3*y*x+c,recursive=true)==729*y^2*x^3*z*x^2*z+x^2*c*y*z*x^2*z+9*x*c*y*x*z*x^2*z-27*y*x^2*c*z*x^2*z+81*y*x*c*x*z*x^2*z-243*y*c*x^2*z*x^2*z+81*c*y*x^2*z*x^2*z-3*x*c^2*z*x^2*z-27*c^2*x*z*x^2*z+9*c*x*c*z*x^2*z-3*y*x*c+c^2; #DIFFERENT from reverse=false
        end
    end
end


@polyvar q w e r

@testset "Commutative sub_monomial" begin
    @test sub_monomial(q^3*r^2,q^2*r,e) == q*r*e
    @test sub_monomial(q^2*r^2, q*r,8) == 64
    @test sub_monomial(q*r,q^2*r^2,e) == q*r
    @test sub_monomial(q^2*r^2, q*r,e) == e^2
    @test sub_monomial(q^6*r^2,q^2*r,e) == q^2*e^2
    @test sub_monomial(3*q^4*r^2+q^6*r^2,q^2*r,e) == 3*e^2+q^2*e^2
    @test sub_monomial(5*q^4*r^6,q*r^2,-2*e+1) == -40*q*e^3+60*q*e^2-30*q*e+5*q
end
