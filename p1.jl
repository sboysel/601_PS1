## ----------------------------------------------------------------------------
## Course: ECON 601
## Instructor: Michael Magill
## Problem: 1
## Author: Sam Boysel
## Date: 8/23/2017
## Desciption:
## ----------------------------------------------------------------------------

## (1) Setup ------------------------------------------------------------------
# Pkg.add("JuMP")
# Pkg.add("Clp")
# Pkg.add("Ipopt")

using JuMP, Clp, Ipopt

function init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
  	# m = Model(solver = ClpSolver())
  	m = Model(solver = IpoptSolver()) 
  	@variable(m, x_1_0 >= 0.0)
  	@variable(m, x_1_1 >= 0.0)
	@variable(m, x_1_2 >= 0.0)
	@variable(m, x_1_3 >= 0.0)
	@variable(m, x_1_4 >= 0.0)
	# Agent 2
	@variable(m, x_2_0 >= 0.0)
	@variable(m, x_2_1 >= 0.0)
	@variable(m, x_2_2 >= 0.0)
	@variable(m, x_2_3 >= 0.0)
	@variable(m, x_2_4 >= 0.0)
	# Agent 3
	@variable(m, x_3_0 >= 0.0)
	@variable(m, x_3_1 >= 0.0)
	@variable(m, x_3_2 >= 0.0)
	@variable(m, x_3_3 >= 0.0)
	@variable(m, x_3_4 >= 0.0)
	# Prices
	@variable(m, π_0 == 1.0)
	@variable(m, π_1 >= 0.0)
	@variable(m, π_2 >= 0.0)
	@variable(m, π_3 >= 0.0)
	@variable(m, π_4 >= 0.0)
	# discount factor
	δ = 0.95
	## (1.2) Aggregate welfare --------------------------------------------
	@NLobjective(
		m,
		Max,
		# Agent 1
		(1 / (1 - α)) * (a[1] + x_1_0)^(1 - α) +
		δ * p[1, 1] * p[2, 1] * (1 / (1 - α)) * (a[1] + x_1_1)^(1 - α) +
		δ * p[1, 1] * (1 - p[2, 1]) * (1 / (1 - α)) * (a[1] + x_1_2)^(1 - α) +
		δ * (1 - p[1, 1]) * p[2, 1] * (1 / (1 - α)) * (a[1] + x_1_3)^(1 - α) +
		δ * (1 - p[1, 1]) * (1 - p[2, 1]) * (1 / (1 - α)) * (a[1] + x_1_4)^(1 - α) +
		# Agent 2
		(1 / (1 - α)) * (a[2] + x_2_0)^(1 - α) +
		δ * p[1, 2] * p[2, 2] * (1 / (1 - α)) * (a[2] + x_2_1)^(1 - α) +
		δ * p[1, 2] * (1 - p[2, 2]) * (1 / (1 - α)) * (a[2] + x_2_2)^(1 - α) +
		δ * (1 - p[1, 2]) * p[2, 2] * (1 / (1 - α)) * (a[2] + x_2_3)^(1 - α) +
		δ * (1 - p[1, 2]) * (1 - p[2, 2]) * (1 / (1 - α)) * (a[2] + x_2_4)^(1 - α) +
		# Agent 3
		(1 / (1 - α)) * (a[3] + x_3_0)^(1 - α) +
		δ * p[1, 3] * p[2, 3] * (1 / (1 - α)) * (a[3] + x_3_1)^(1 - α) +
		δ * p[1, 3] * (1 - p[2, 3]) * (1 / (1 - α)) * (a[3] + x_3_2)^(1 - α) +
		δ * (1 - p[1, 3]) * p[2, 3] * (1 / (1 - α)) * (a[3] + x_3_3)^(1 - α) +
		δ * (1 - p[1, 3]) * (1 - p[2, 3]) * (1 / (1 - α)) * (a[3] + x_3_4)^(1 - α)
	)
	## (1.3) Contraints
	## (1.3.1) State-contingent market clearing conditions ----------------
	# s = 0 
	@constraint(
		m,
		x_1_0 + x_2_0 + x_3_0 <= ω_1[1] + ω_2[1] + ω_3[1]
	)
	# s = 1 
	@constraint(
		m,
		x_1_1 + x_2_1 + x_3_1 <= ω_1[2] + ω_2[2] + ω_3[2]
	)
	# s = 2 
	@constraint(
		m,
		x_1_2 + x_2_2 + x_3_2 <= ω_1[3] + ω_2[3] + ω_3[3]
	)
	# s = 3 
	@constraint(
		m,
		x_1_3 + x_2_3 + x_3_3 <= ω_1[4] + ω_2[4] + ω_3[4]
	)
	# s = 4
	@constraint(
		m,
		x_1_4 + x_2_4 + x_3_4 <= ω_1[5] + ω_2[5] + ω_3[5]
	)
	## (1.3.2) Agent 1's state-contingent budget constraints --------------
	# s = 1
	@constraint(
		m,
		x_1_0 * π_0 + x_1_1 * π_1 <= ω_1[1] * π_0 + ω_1[2] * π_1
	)
	# s = 2
	@constraint(
		m,
		x_1_0 * π_0 + x_1_2 * π_2 <= ω_1[1] * π_0 + ω_1[3] * π_2
	)
	# s = 3
	@constraint(
		m,
		x_1_0 * π_0 + x_1_3 * π_3 <= ω_1[1] * π_0 + ω_1[4] * π_3
	)
	# s = 4
	@constraint(
		m,
		x_1_0 * π_0 + x_1_4 * π_4 <= ω_1[1] * π_0 + ω_1[5] * π_4
	)
	## (1.3.3) Agent 2's state-contingent budget constraints --------------
	# s = 1
	@constraint(
		m,
		x_2_0 * π_0 + x_2_1 * π_1 <= ω_2[1] * π_0 + ω_2[2] * π_1
	)
	# s = 2
	@constraint(
		m,
		x_2_0 * π_0 + x_2_2 * π_2 <= ω_2[1] * π_0 + ω_2[3] * π_2
	)
	# s = 3
	@constraint(
		m,
		x_2_0 * π_0 + x_2_3 * π_3 <= ω_2[1] * π_0 + ω_2[4] * π_3
	)
	# s = 4
	@constraint(
		m,
		x_2_0 * π_0 + x_2_4 * π_4 <= ω_2[1] * π_0 + ω_2[5] * π_4
	)
	## (1.3.4) Agent 3's state-contingent budget constraints --------------
	# s = 1
	@constraint(
		m,
		x_3_0 * π_0 + x_3_1 * π_1 <= ω_3[1] * π_0 + ω_3[2] * π_1
	)
	# s = 2
	@constraint(
		m,
		x_3_0 * π_0 + x_3_2 * π_2 <= ω_3[1] * π_0 + ω_3[3] * π_2
	)
	# s = 3
	@constraint(
		m,
		x_3_0 * π_0 + x_3_3 * π_3 <= ω_3[1] * π_0 + ω_3[4] * π_3
	)
	# s = 4
	@constraint(
		m,
		x_3_0 * π_0 + x_3_4 * π_4 <= ω_3[1] * π_0 + ω_3[5] * π_4
	)
	# non-zero prices
	slack = 1e-6
	@constraint(m, π_1 >= slack)
	@constraint(m, π_2 >= slack)
	@constraint(m, π_3 >= slack)
	@constraint(m, π_4 >= slack)
	X = [[x_1_0, x_1_1, x_1_2, x_1_3, x_1_4],
       [x_2_0, x_2_1, x_2_2, x_2_3, x_2_4],
       [x_3_0, x_3_1, x_3_2, x_3_3, x_3_4]]
	P = [π_0, π_1, π_2, π_3, π_4]
  	m, X, P
end

# convenience function to print solutions
function print_solution(x, p, filename)
	println("A-D Equilibrium:")
    	println(" π = {π_0 = 1, ..., π_4}:")
    	println(" - $(map(getvalue, p))")
    	println(" x = {x_0, ..., x_4}")
    	println(" - i = 1: $(map(getvalue, x[1]))")
    	println(" - i = 2: $(map(getvalue, x[2]))")
    	println(" - i = 3: $(map(getvalue, x[3]))")
end

## (3) No risk, identical beliefs ---------------------------------------------
# [α, a, p, b, ϵ, ω_1, ω_2, ω_3]
## (3.1) Parameters
α = 2.0
a = [0.0, 0.0, 0.0]
# probabilities
# - p[k, i] = agent i's belief that firm k is successful
p = [0.5 0.5 0.5;
     0.5 0.5 0.5]
# non-stochastic wealth
b = [500.0, 500.0, 1000.0]
# stochastic wealth
ϵ = [0.0, 0.0]
# endowment vectors
ω_1 = [0.0, b[1] + ϵ[1], b[1] + ϵ[1], b[1] - ϵ[1], b[1] - ϵ[1]]
ω_2 = [0.0, b[2] + ϵ[2], b[2] - ϵ[2], b[2] + ϵ[2], b[2] - ϵ[2]]
ω_3 = [b[3], 0.0, 0.0, 0.0, 0.0]

# Initiate model and solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

## (4) Some risk, identical beliefs -------------------------------------------
## (4.1) Parameters
# stochastic wealth
ϵ = [100.0, 200.0]
# endowment vectors
ω_1 = [0.0, b[1] + ϵ[1], b[1] + ϵ[1], b[1] - ϵ[1], b[1] - ϵ[1]]
ω_2 = [0.0, b[2] + ϵ[2], b[2] - ϵ[2], b[2] + ϵ[2], b[2] - ϵ[2]]
ω_3 = [b[3], 0.0, 0.0, 0.0, 0.0]

# Initiate model and solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

## (5) Some risk, variation in investor beliefs -------------------------------
## (5.1) Parameters
# probabilities
# - p[k, i] = agent i's belief that firm k is successful
p = [0.5 0.5 2/3;
     0.5 0.5 2/3]

# Initiate model solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

## (6) Some risk, variation in preferences ------------------------------------
## (6.1) Parameters
a = [0.0, 0.0, 500.0]
# probabilities
# - p[k, i] = agent i's belief that firm k is successful
p = [0.5 0.5 0.5;
     0.5 0.5 0.5]
# non-stochastic wealth
b = [500.0, 500.0, 1000.0]
# stochastic wealth
ϵ = [100.0, 200.0]
# endowment vectors
ω_1 = [0.0, b[1] + ϵ[1], b[1] + ϵ[1], b[1] - ϵ[1], b[1] - ϵ[1]]
ω_2 = [0.0, b[2] + ϵ[2], b[2] - ϵ[2], b[2] + ϵ[2], b[2] - ϵ[2]]
ω_3 = [b[3], 0.0, 0.0, 0.0, 0.0]

# Initiate model and solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

## (7) No risk, variation in preferences --------------------------------------

## (a)
a = [0.0, 0.0, 0.0]
# probabilities
# - p[k, i] = agent i's belief that firm k is successful
p = [0.5 0.5 0.5;
     0.5 0.5 0.5]
# non-stochastic wealth
b = [500.0, 500.0, 500.0]
# stochastic wealth
ϵ = [0.0, 0.0]
# endowment vectors
ω_1 = [0.0, b[1] + ϵ[1], b[1] + ϵ[1], b[1] - ϵ[1], b[1] - ϵ[1]]
ω_2 = [0.0, b[2] + ϵ[2], b[2] - ϵ[2], b[2] + ϵ[2], b[2] - ϵ[2]]
ω_3 = [b[3], b[3], b[3], b[3], b[3]]

# Initiate model and solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

## (b)
a = [0.0, 0.0, 0.0]
# probabilities
# - p[k, i] = agent i's belief that firm k is successful
p = [2/3 1/3 3/4;
     2/3 1/2 1/4]
# non-stochastic wealth
b = [500.0, 500.0, 500.0]
# stochastic wealth
ϵ = [0.0, 0.0]
# endowment vectors
ω_1 = [0.0, b[1] + ϵ[1], b[1] + ϵ[1], b[1] - ϵ[1], b[1] - ϵ[1]]
ω_2 = [0.0, b[2] + ϵ[2], b[2] - ϵ[2], b[2] + ϵ[2], b[2] - ϵ[2]]
ω_3 = [b[3], b[3], b[3], b[3], b[3]]

# Initiate model and solve for equilibrium
m, X, P = init_model(α, a, p, b, ϵ, ω_1, ω_2, ω_3)
status = solve(m)
print_solution(X, P)

