# Franklin.jl Blog :ringed_planet:

## Install Franklin

First, install the [Julia Programming Language](https://julialang.org/).

Then install the [Franklin](https://franklinjl.org/) package.

```julia
using Pkg
Pkg.add("Franklin")

using Franklin
```

## Create Your New Site

You can create a vanilla site by running `newsite` with no arguments.

```julia
newsite()
```

If you want to start with a [template](9https://github.com/tlienart/FranklinTemplates.jl), **pur-sm** for example, pass that to the `template` keyword.

```julia
newsite("mySite", template="pure-sm")
```

## TODO

- add plot options to literate script
- outline first post
- move to gh pages
- change landing page to show latest posts
