# This file was generated, do not modify it.

# define function f
f(λ) = -1 + λ + λ^2
# define derivative of f
ḟ(λ) = 1 + 2*λ
# define function to calculate the next λ
next(λ) = λ - f(λ)/ḟ(λ)
# create a list of λs starting with 1
λs = [1.0]
# calculate next four
for n ∈ 1:4
    push!(λs, next(λs[n]))
end
# display results
@show λs

# define function to calculate net present value
function net_present_value(investment, revenue, year, rate)
    -investment + revenue/(1+rate)^year
end
# define empty array for values
values = []
# populate some values
for i ∈ 1:20
    append!(values, net_present_value(1, i+1, i, 0.10))
end
# display some values
@show values

using DataFrames
df = DataFrame(Dict(:year => 1:20, :revenue => values))
show(df)

maximum(values)

using PyPlot
figure(figsize=(4, 2))
plot(df.year, df.revenue)

xlabel("Year", fontsize=14)
ylabel("Revenue", fontsize=14)

plt.savefig(joinpath(@OUTPUT, "invsci-01-time-to-harvest.svg")) # hide

