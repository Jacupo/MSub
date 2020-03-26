using DynamicPolynomials
using Test
using MSub

@ncpolyvar x y z a b

@testset "Find_monomial" begin
    @testset "Find PolyVar" begin
        @test MSub.Find_monomial(x*y*z*x*z*y*x,x)==[1,4,7];
        @test MSub.Find_monomial(x*y*x^2*z,x)==[1,3];
    end
    @testset "Find Monomial(1)" begin
        @test MSub.Find_monomial(x*y*z*x*z*y*x,Monomial{false}([x],[1]))==[1,4,7];
    end
    @testset "Find Monomial(>1)" begin
        @test MSub.Find_monomial(x*y*z*x*z^2*x*y,x*y)==[1,6];
        @test MSub.Find_monomial(x^3*y^2*z,x*y)==[1];
        @test MSub.Find_monomial(x*y*z*x*z^2*x*y^2,x*y^2)==[6];
        @test MSub.Find_monomial(x*y*z*y*z^2*y,x*y*z)==[1];
        @test MSub.Find_monomial(x*y*z^2*y*z^2*y,x*y*z)==[1];
        @test MSub.Find_monomial(x*y*z^2*y*z^2*y*x*y*z,x*y*z)==[1,7];
        @test MSub.Find_monomial(x*y*z*y*z^2*y*x*y*z^3,x*y*z^2)==[7];
    end
end

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




@testset "Sub_monomial" begin

    @testset "Same as subs" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,x*x*x*x*x*x*x*x*x*x,a)==x*y*z*x*z*y*z*x
        @test Sub_monomial(x*y*z*x*z*y*z*x,x,a)==a*y*z*a*z*y*z*a
        @test Sub_monomial(x*y*z*x*z*y*z*x,z,a)==x*y*a*x*a*y*a*x
        @test Sub_monomial(x*y*z*x^2*z*y*z*x,x,y)==y^2*z*y^2*z*y*z*y
        #Problem: I could have to substitite x in x^2
        #or even worse xy^2 in x^3y^6? This case NO for NCVAR
        #Solved?
    end
    @testset "take monomial put variable" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,z*x,a)==x*y*a*z*y*a
        @test Sub_monomial(x*y*z*x*z*y*z*x,z*x,y)==x*y^2*z*y^2
        @test Sub_monomial(x*y*z*x^2*z*y*z*x,z*x^2,a)==x*y*a*z*y*z*x
        @test Sub_monomial(x*y*z*x^2*z*y*z*x,z*x^3,a)==x*y*z*x^2*z*y*z*x
    end
    @testset "take variable put monomial" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,x,a*b)==a*b*y*z*a*b*z*y*z*a*b
        @test Sub_monomial(x*y*z*x*z*y*z*x^3,x,a*b)==a*b*y*z*a*b*z*y*z*a*b*a*b*a*b
    end

    @testset "take variable put number" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,x,2)==8*y*z*z*y*z
    end
    @testset "take monomial put number" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,x*y,2)==2*z*x*z*y*z*x
        @test Sub_monomial(x*y*z*x*z*y*z*x,z*x,2)==4*x*y*z*y
    end

    @testset "take monomial put monomial" begin
        @test Sub_monomial(x*y*z*x*z*y*z*x,x*y,a*b)==a*b*z*x*z*y*z*x
        @test Sub_monomial(x*y*z*x^2*z*y*z*x,z*x,a*b)==x*y*a*b*x*z*y*a*b
        @test Sub_monomial(x^3*y*z*x^2*z,x*y,a*b)==x^2*a*b*z*x^2*z
        @test Sub_monomial(x^3*y^2*z*x^2*z,x*y,a*b)==x^2*a*b*y*z*x^2*z
    end
end

@testset "Sub2" begin
    @test Sub2(x*y*z+2*z*x*y,z*x,a)==x*y*z+2*a*y
end
