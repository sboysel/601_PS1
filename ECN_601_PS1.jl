##import necessary libraries
using JuMP
using Clp


##set model and solve method
test = Model(solver = ClpSolver())


##assign exogenous parameter variables
beta1 = 500.0
beta2 = 500.0
beta3 = 1000.0
epsilon1 = 0.0
epsilon2 = 0.0
epsilon3 = 0.0
alpha = 2.0
a1 = 0.0
a2 = 0.0
a3 = 0.0
delta1 = 0.95
delta2 = 0.95
delta3 = 0.95
rho1 = [1.0, 0.25, 0.25, 0.25, 0.25]
rho2 = [1.0, 0.25, 0.25, 0.25, 0.25]
rho3 = [1.0, 0.25, 0.25, 0.25, 0.25]


##assign endogenous variables

    #price variables
@variable(test, pi[1:5] >= 0.0)
JuMP.fix(pi[1], 1.0)

    #consumption variables
@variables test begin
    x1[1:5] >= 0.0
    x2[1:5] >= 0.0
    x3[1:5] >= 0.0
end

    #endowment variables
@variables test begin
    o1[1:5] == 0.0
    o2[1:5] == 0.0
    o3[1:5] == 0.0
end
JuMP.fix(o1[2], beta1 + epsilon1)
JuMP.fix(o1[3], beta1 + epsilon1)
JuMP.fix(o1[4], beta1 - epsilon1)
JuMP.fix(o1[5], beta1 - epsilon1)
JuMP.fix(o2[2], beta2 + epsilon2) 
JuMP.fix(o2[3], beta2 - epsilon2)
JuMP.fix(o2[4], beta2 + epsilon2) 
JuMP.fix(o2[5], beta2 - epsilon2)
JuMP.fix(o3[1], beta3)


##set individual utility functions
#@expressions test begin 
#    u1, (1/(1-alpha))*(a1+x1[1])^(1-alpha)+delta1*sum(rho1[i]*((1/(1-alpha))*(a1+x1[i])^(1-alpha)) for i in 2:5)
#    u2, (1/(1-alpha))*(a2+x2[1])^(1-alpha)+delta2*sum(rho2[i]*((1/(1-alpha))*(a2+x2[i])^(1-alpha)) for i in 2:5)
#    u3, (1/(1-alpha))*(a3+x3[1])^(1-alpha)+delta3*sum(rho3[i]*((1/(1-alpha))*(a3+x3[i])^(1-alpha)) for i in 2:5)
#end

#######################################################################
#this is a dummy utility function for now to test the rest of the code#
#######################################################################
@expressions test begin 
    u1, sum(x1[i] for i in 1:5)
    u2, sum(x2[i] for i in 1:5)
    u3, sum(x3[i] for i in 1:5)
end


##set constraints

    #endowment/consumption sums
@expressions test begin
    sumo1, sum(pi[i]*o1[i] for i in 1:5)
    sumo2, sum(pi[i]*o2[i] for i in 1:5)
    sumo3, sum(pi[i]*o3[i] for i in 1:5)    
    sumx1, sum(pi[i]*x1[i] for i in 1:5)
    sumx2, sum(pi[i]*x2[i] for i in 1:5)
    sumx3, sum(pi[i]*x3[i] for i in 1:5)
end

    #market clearing expressions
@expressions test begin
    mkt1, (x1[1]+x2[1]+x3[1])-(o1[1]+o2[1]+o3[1])
    mkt2, (x1[2]+x2[2]+x3[2])-(o1[2]+o2[2]+o3[2])
    mkt3, (x1[3]+x2[3]+x3[3])-(o1[3]+o2[3]+o3[3])
    mkt4, (x1[4]+x2[4]+x3[4])-(o1[4]+o2[4]+o3[4])
end

#the below loop seems like it should work, but doesn't, not a priority though as above works just as well.
#mkts = [mkt1, mkt2, mkt3, mkt4]
#for (i, mkt) in enumerate(mkts)
#    @expression(test, mkt, (x1[i]+x2[i]+x3[i])-(o1[i]+o2[i]+o3[i]))
#end

    #consumption & market clearing constraints
@constraints test begin
    #consumption <= income constraints
    sumx1 <= sumo1
    sumx2 <= sumo2
    sumx3 <= sumo3
    #market clearing constraints
    mkt1 == 0.0
    mkt2 == 0.0
    mkt3 == 0.0
    mkt4 == 0.0
end


##set objective function
@objective(test, Max, (u1+u2+u3))


##solve model and print results
print(test)
result = solve(test)

println("objective value: ", getobjectivevalue(test))
println("x1 = ", getvalue(sumx1))
println("x2 = ", getvalue(sumx2))
println("x3 = ", getvalue(sumx3))
println("pi1 = ", getvalue(pi[1]))
println("pi2 = ", getvalue(pi[2]))
println("pi3 = ", getvalue(pi[3]))
println("pi4 = ", getvalue(pi[4]))
println("pi5 = ", getvalue(pi[5]))
