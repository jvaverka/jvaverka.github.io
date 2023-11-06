import Pkg

Pkg.activate(@__DIR__)
Pkg.add("IJulia")
Pkg.build("IJulia")

run(`jupyter kernelspec list`)