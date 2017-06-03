function [ EuclideanDistanceMatrix ] = GetNeighborEuclideanDistanceMatrix(NeighborMatrix, vertices)

% NeighborMatrix => Neighbor matrix
% EuclideanDistanceMatrix => Distance Matrix

[N,~] = size(NeighborMatrix);

EuclideanDistanceMatrix = zeros(size(NeighborMatrix));

for i = 1:1:N
    for j = 1:1:N
         if NeighborMatrix(i,j) == 1
             v1 = vertices(i,:);
             v2 = vertices(j,:);
             d = sqrt((v2(1)-v1(1))^2+(v2(2)-v1(2))^2+(v2(3)-v1(3))^2);
             EuclideanDistanceMatrix(i,j) = d;
         end;
    end;
end;

end

