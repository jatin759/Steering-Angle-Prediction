function [ydash] = l3test(X, w1, w2, w3)
    
    inp = double(X) * double(w1'); 
    z1 = defsigmoid(inp);
    z1 = [ones(size(z1,1),1) z1];
    
    inp = double(z1) * double(w2');
    z2 = defsigmoid(inp);
    z2 = [ones(size(z2,1),1) z2];
    
    ydash = double(z2) * double(w3');

end