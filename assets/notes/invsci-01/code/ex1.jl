# This file was generated, do not modify it. # hide
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