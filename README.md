# ExtremeBoilerplate
Boilerplate which are actually not safe to use! 




```julia
P = Param(0.1, 50, 35)
fieldnames(P)  # fieldnames(typeof(P)) # This is equvalent to fieldnames(typeof(P))  # I believe 99% of us used it wrong at first because this could have been so evident this way... 

String(P)  # "$P"
```