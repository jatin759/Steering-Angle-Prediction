function [ z ] = defsigmoid( x )

if x >= 0
    z = exp(-x);
    z = 1 ./ (1 + z);
else
    z = exp(x);
    z = z ./ (1 + z);
end

end

