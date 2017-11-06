function [ soft ] = softmax( z , v )

soft = exp(z*v);
soft = diag(1./sum(soft,2))*soft;

end

