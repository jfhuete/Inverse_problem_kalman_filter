function [ H ] = H_IdentityMatrix(faces)

Nvertex = max(max(faces));

H = eye(Nvertex);

end

