# # Problem 4
# The IRR is generally calculated using an iterative procedure.
# Suppose that we define $f(\lambda) = -a_{1} + a_{2}\lambda^{2} + \ldots + a_{n}\lambda^{n}$,
# where all $a_{i}$'s are positive and $n > 1$.
# Here is an iterative technique that generates a sequence
# $\lambda_{0}, \lambda_{1}, \lambda_{2}, \ldots \lambda_{k}, \ldots$
# of estimates that converges to the root $\overline{\lambda} > 0$, solving $f(\overline{\lambda}) = 0$.
# Start with any $\lambda_{0} > 0$ close to the solution.
# Assuming $\lambda_{k}$ has been calculated, evaluate
#
# $$
# f'(\lambda_{k}) = a_{1} + 2a_{2}\lambda_{k} + 3a_{3}\lambda_{k}^{2} + \ldots + na_{n}\lambda_{k}^{n-1}
# $$
#
# and define
#
# $$
# \lambda_{k+1} = \lambda_{k} - \frac{f(\lambda_{k})}{f'(\lambda_{k})}
# $$
#
# This is Newton's method.
# It is based on approximating the function $f$ by a line tangent to its graph at $\lambda_{k}$.
# Try the procedure on $f(\lambda) = -1 + \lambda + \lambda^{2}$.
# Start with $\lambda_{0} = 1$ and compute four additional estimates.
#
# ## Solution
#
# We know
#
# $$
# \begin{aligned}
# \lambda_{0} &= 1 \\
# \lambda_{k+1} &= \lambda_{k} - \frac{f(\lambda_{k})}{f'(\lambda_{k})} \\
# f(\lambda) &= -1 + \lambda + \lambda^{2} \\
# f'(\lambda) &= 1 + 2\lambda \\
# \end{aligned}
# $$
#
# Using all these equations we can compute four additional estimates.

## define function f
f(λ) = -1 + λ + λ^2
## define derivative of f
ḟ(λ) = 1 + 2*λ
## define function to calculate the next λ
next(λ) = λ - f(λ)/ḟ(λ)
## create a list of λs starting with 1
λs = [1.0]
## calculate next four
for n ∈ 1:4
    push!(λs, next(λs[n]))
end
## display results
@show λs

# # Problem 5
#
# Suppose that you have the opportunity to plant trees that alter can be sold for lumber. This project requires an initial outlay of money in order to purchase and plant the seedlings. No other cash flow occurs until trees are harvested. However, you have a choice as to when to harvest. If you harvest after 1 year, you get your return quickly; but if you wait, the trees will have additional growth and the revenue generated from the sale of the trees will be greater. Assume that the case flow streams associated with these alternatives are:
#
# - Wait $1$ year: $(-1, 2)$
# - Wait $2$ year: $(-1, ,0, 3)$
# - Wait $3$ year: $(-1, 0, 0, 4)$
# - $\vdots$
# - Wait $n$ year: $(-1, 0, 0, \ldots, n+1)$
#
# The prevailing interest rate is 10%. When is the best time to cut the trees?
#
# ## Solution
#
# Let’s first define a function for calculating the Net Present Value, say on a cash flow stream that looks like $(x_{0}, \ldots, x_{n})$ where $r$ is the prevailing interest rate and $k$ is the number of years waited to harvest:
#
# $$
# NPV = -x_{0} + \frac{x_{k}}{(1+r)^{k}}
# $$
#
# We can create a function to calculate the **_NPV_** given a _cash flow stream_ and _interest rate_. Let's create a table of the first several values to determine the optimal time to harvest.

## define function to calculate net present value
function net_present_value(investment, revenue, year, rate)
    -investment + revenue/(1+rate)^year
end
## define empty array for values
values = []
## populate some values
for i ∈ 1:20
    append!(values, net_present_value(1, i+1, i, 0.10))
end
## display some values
@show values

# To make reading easier, we can create a table or `dataframe`.

using DataFrames
df = DataFrame(Dict(:year => 1:20, :revenue => values))
show(df)

# A quick glance reveals the maximum revenue.

maximum(values)
#+
using PyPlot
figure(figsize=(4, 2))
plot(df.year, df.revenue)

xlabel("Year", fontsize=14)
ylabel("Revenue", fontsize=14)

plt.savefig(joinpath(@OUTPUT, "invsci-01-time-to-harvest.svg")) # hide

# \figalt{Time to Harvest}{invsci-01-time-to-harvest.svg}
#
# We can see that the graph levels off at the top, and upon inspection of the table we confirm that **years 9 and 10** will yield optimal revenue.
