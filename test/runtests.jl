using DynamicPolynomials
using Test
using MSub

@ncpolyvar x y z a b c

#=
@testset "find_monomial" begin
    @testset "Find PolyVar" begin
        @test MSub.find_monomial(x*y*z*x*z*y*x,x)==[1,4,7];
        @test MSub.find_monomial(x*y*x^2*z,x)==[1,3];
    end
    @testset "Find Monomial(1)" begin
        @test MSub.find_monomial(x*y*z*x*z*y*x,Monomial{false}([x],[1]))==[1,4,7];
    end
    @testset "Find Monomial(>1)" begin
        @test MSub.find_monomial(x*y*z*x*z^2*x*y,x*y)==[1,6];
        @test MSub.find_monomial(x^3*y^2*z,x*y)==[1];
        @test MSub.find_monomial(x*y*z*x*z^2*x*y^2,x*y^2)==[6];
        @test MSub.find_monomial(x*y*z*y*z^2*y,x*y*z)==[1];
        @test MSub.find_monomial(x*y*z^2*y*z^2*y,x*y*z)==[1];
        @test MSub.find_monomial(x*y*z^2*y*z^2*y*x*y*z,x*y*z)==[1,7];
        @test MSub.find_monomial(x*y*z*y*z^2*y*x*y*z^3,x*y*z^2)==[7];
    end
end
=#

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

@testset "sub_monomial" begin

    @testset "Arg(1)=Number" begin
        @test sub_monomial(4, x*y, a) == 4
    end

    @testset "Same as subs" begin
        @test sub_monomial(x*y*z*x*z*y*z*x,x*x*x*x*x*x*x*x*x*x,a)==x*y*z*x*z*y*z*x
        @test sub_monomial(x*y*z*x*z*y*z*x,x,a)==a*y*z*a*z*y*z*a
        @test sub_monomial(x*y*z*x*z*y*z*x,z,a)==x*y*a*x*a*y*a*x
        @test sub_monomial(x*y*z*x^2*z*y*z*x,x,y)==y^2*z*y^2*z*y*z*y
        #Problem 1: I could have to substitite x in x^2
        #or even worse xy^2 in x^3y^6? This case NO for NCVAR
        #-->Pay attention with COMMUTATIVE at Problem1, check if subs does it
    end

    @testset "Take variable" begin
        @testset "take variable put number" begin
            @test sub_monomial(7*x*y*z*x*z*y*z*x,x,2)==56*y*z*z*y*z
        end

        @testset "take variable put monomial" begin
            @test sub_monomial(5*x*y*z*x*z*y*z*x,x,a*b)==5*a*b*y*z*a*b*z*y*z*a*b
            @test sub_monomial(x*y*z*x*z*y*z*x^3,x,a*b)==a*b*y*z*a*b*z*y*z*a*b*a*b*a*b
        end

        @testset "take variable put term" begin
            @test sub_monomial(5*x*y*z*x*z*y*z*x,x,3*a*b)==135*a*b*y*z*a*b*z*y*z*a*b
            @test sub_monomial(x*y*z*x*z*y*z*x^3,x,3*a*b)==243*a*b*y*z*a*b*z*y*z*a*b*a*b*a*b
        end

        @testset "take variable put polynomia" begin
            @test sub_monomial(5*y*z*x*z,x,3*a*b+1)==15*y*z*a*b*z+5*y*z^2
            @test sub_monomial(z*x^2*z,x,3*a*b+1)==9*z*a*b*a*b*z+6*z*a*b*z+z^2
        end
    end

    @testset "take monomial" begin
        @testset "take monomial put number" begin
            @test sub_monomial(11*x*y*z*x*z*y*z*x,x*y,2)==22*z*x*z*y*z*x
            @test sub_monomial(x*y*z*x*z*y*z*x,z*x,2)==4*x*y*z*y
        end

        @testset "take monomial put variable" begin
            @test sub_monomial(2*x*y*z*x*z*y*z*x,z*x,a)==2*x*y*a*z*y*a
            @test sub_monomial(x*y*z*x*z*y*z*x,z*x,y)==x*y^2*z*y^2
            @test sub_monomial(3*x*y*z*x^2*z*y*z*x,z*x^2,a)==3*x*y*a*z*y*z*x
            @test sub_monomial(x*y*z*x^2*z*y*z*x+x*z*x^3*x,z*x^3,a)==x*y*z*x^2*z*y*z*x+x*a*x
        end

        @testset "take monomial put monomial" begin
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,a*b)==13*a*b*z*x*z*y*z*x
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,a*b)==x*y*a*b*x*z*y*a*b
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,a*b)==17*x^2*a*b*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,a*b)==x^2*a*b*y*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z+a*x*y*b,x*y,a*b)==x^2*a*b*y*z*x^2*z+a^2*b^2
            @test sub_monomial(z*x*y*z,x*y,x^2*y^2)==z*x^2*y^2*z
        end

        @testset "take monomial put term" begin
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b)==39*a*b*z*x*z*y*z*x
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b)==9*x*y*a*b*x*z*y*a*b
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b)==51*x^2*a*b*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b)==3*x^2*a*b*y*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z+5*a*x*y*c,x*y,3*a*b)==3*x^2*a*b*y*z*x^2*z+15*a^2*b*c
        end

        @testset "take monomial put polynomia" begin
            @test sub_monomial(13*x*y*z*x*z*y*z*x,x*y,3*a*b+1)==39*a*b*z*x*z*y*z*x+13*z*x*z*y*z*x
            @test sub_monomial(x*y*z*x^2*z*y*z*x,z*x,3*a*b+1)==9*x*y*a*b*x*z*y*a*b+3*x*y*a*b*x*z*y+3*x*y*x*z*y*a*b+x*y*x*z*y
            @test sub_monomial(17*x^3*y*z*x^2*z,x*y,3*a*b+1)==51*x^2*a*b*z*x^2*z+17*x^2*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+1)==3*x^2*a*b*y*z*x^2*z+3*x*a*b*z*x^2*z+x*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z,x*y,3*a*b+c)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z
            @test sub_monomial(x^3*y^2*z*x^2*z+x*y*c,x*y,3*a*b+c)==3*x^2*a*b*y*z*x^2*z+x^2*c*y*z*x^2*z+3*a*b*c+c^2
        end
    end


end
