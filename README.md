# ExtremeBoilerplate
Boilerplate which are actually not safe to use! 

They introduce Type piracy too. But it is really great to have!


## Examples
```julia
P = Param(0.1, 50, 35)
fieldnames(P)  # fieldnames(typeof(P)) # This is equvalent to fieldnames(typeof(P))  # I believe 99% of us used it wrong at first because this could have been so evident this way... 

String(P)  # "$P"

available_memory() # very fast way to get available memory in julia. 

```

Also some more, see src/ExtremeBoilerplate.jl