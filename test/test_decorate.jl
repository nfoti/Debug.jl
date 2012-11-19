load("debug.jl")

module TestDebugEval
using Base, Debug
import Debug.decorate

code = quote
    function f(x::Int)
        y = 0
        while x > 0
            x -= y
            y += 1
        end
        y
    end
end

reconstruct(node::Union(Leaf,Sym,Line)) = node.ex
function reconstruct(ex::Union(Block,Expr))
    expr(get_head(ex), {reconstruct(arg) for arg in ex.args})
end

dcode = analyze(code)
rcode = reconstruct(dcode)

@assert rcode == code

end
