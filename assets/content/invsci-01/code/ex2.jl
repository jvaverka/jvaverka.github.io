# This file was generated, do not modify it. # hide
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