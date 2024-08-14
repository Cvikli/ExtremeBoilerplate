module ExtremeBoilerplate



get_parametric(x::Val{P}) where P = P  # I guess there is a simpler way... but for now this was enough.

# I hate lambda functions sometime...
noop(vargs...) = nothing 

# It is just crazy how many time did I try to convert anything to string like this... Let's make it default...
Base.String(x) = "$x" 



# LIKE WHY this isn't default! :D
Base.fieldnames(x::Any)             = fieldnames(typeof(x))    # In case of Any we need runtime information... I guess this should work like this 
# Base.fieldnames(x::Type{TYPE}) where TYPE = fieldnames(TYPE)         # If we have compile time information other than Any then we could use things like this? 
# Base.fieldnames(x) = fieldnames(typeof(x))  # general... 


# Curried functions:
Base.filter(f::Function) = L -> Base.filter(f, L)
Base.map(f::Function)    = L -> map(f, L)
Base.reshape(s1::Union{Colon, Int})                                                                      = arr -> reshape(arr, s1)
Base.reshape(s1::Union{Colon, Int}, s2::Union{Colon, Int})                                               = arr -> reshape(arr, s1, s2)
Base.reshape(s1::Union{Colon, Int}, s2::Union{Colon, Int}, s3::Union{Colon, Int})                        = arr -> reshape(arr, s1, s2, s3)
Base.reshape(s1::Union{Colon, Int}, s2::Union{Colon, Int}, s3::Union{Colon, Int}, s4::Union{Colon, Int}) = arr -> reshape(arr, s1, s2, s3, s4)


# To handle different nested array structs... Not comprehensive... be noted!
map_array(fn::Function, arr::AbstractArray{Float32,N})           where N = fn(arr)
map_array(fn::Function, arr::AbstractArray{Int64,N})             where N = fn(arr)
map_array(fn::Function, arr::Vector{Function})                           = Vector{Function}(undef, length(arr))
map_array(fn::Function, arr::Vector{T})                          where T = [map_array(fn, v) for v in arr] # this is a less strict option.
map_array(fn::Function, arr::Array{Array{Float32,N},1})          where N = [map_array(fn, v) for v in arr]
map_array(fn::Function, arr::Array{Array{Int64,N},1})            where N = [map_array(fn, v) for v in arr]
map_array(fn::Function, arr::Array{Array{Function,N},1})         where N = [map_array(fn, v) for v in arr]
map_array(fn::Function, arr::Array{Array{Array{Float32,N},1},1}) where N = [map_array(fn, v) for v in arr]
map_array(fn::Function, arr::Tuple{A})               where {A}           = (map_array(fn, arr[1]),)
map_array(fn::Function, arr::Tuple{A,B})             where {A,B}         = (map_array(fn, arr[1]), map_array(fn, arr[2]))
map_array(fn::Function, arr::Tuple{A,B,C})           where {A,B,C}       = (map_array(fn, arr[1]), map_array(fn, arr[2]), map_array(fn, arr[3]))
map_array(fn::Function, arr::Tuple{A,B,C,D})         where {A,B,C,D}     = (map_array(fn, arr[1]), map_array(fn, arr[2]), map_array(fn, arr[3]), map_array(fn, arr[4]))
map_array(fn::Function, arr::Tuple{A,B,C,D,E})       where {A,B,C,D,E}   = (map_array(fn, arr[1]), map_array(fn, arr[2]), map_array(fn, arr[3]), map_array(fn, arr[4]), map_array(fn, arr[5]))
map_array(fn::Function, arr::Tuple{A,B,C,D,E,F})     where {A,B,C,D,E,F} = (map_array(fn, arr[1]), map_array(fn, arr[2]), map_array(fn, arr[3]), map_array(fn, arr[4]), map_array(fn, arr[5]), map_array(fn, arr[6]))
map_array(fn::Function) = d -> map_array(fn, d)


map_assign!(a, b::AbstractArray{Float32,N}) where {N} = a .= b
map_assign!(a, b::AbstractArray{Function,1})          = Vector{Function}(undef, length(b))
map_assign!(a, b::AbstractArray)                      = for i = 1:length(b)  map_assign!(a[i], b[i]) end
map_assign!(a, b::Tuple)                              = for i = 1:length(b) map_assign!(a[i], b[i]) end



@inline equalize(args...)             = equalize(args)
@inline equalize(args::AbstractArray) = begin
  common_size = minimum(length.(args))
	for i in eachindex(args)
		common_size != length(args[i]) && (args[i] = args[i][1:common_size])
	end
	args
end
@inline equalize(args::T)     where T = begin
  common_size = minimum(length.(arrs))
  (common_size != length(a) ? a[1:common_size] : a for a in args)
end
macro equalize(expr)
  esc(:($expr = equalize($expr)))
end

# TODO... @get arrayobj.[...]
macro get(obj)  # obj of Dict... @get dictobj.["TD3_MINI", "TD5_BIG"]
	obj.head ≠ :. && error("syntax: expected: `dictionary.[keys...]`.")
		dict_obj = ((obj.args[1]))
		dict_keys = ((obj.args[2].args[1].args))
		println(obj)
		println(dict_obj)
		println(dict_keys)
		
		:([$dict_obj[k] for k in $dict_keys])
end


available_memory() = parse(Int, "$(read(`grep MemAvailable /proc/meminfo`))"[14:end-3])

end # module ExtremeBoilerplate
