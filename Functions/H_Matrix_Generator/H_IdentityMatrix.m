function [ H ] = H_IdentityMatrix(model)
 
    [Nvertex, ~]= size(model.vertices);

    H = eye(Nvertex);

end

