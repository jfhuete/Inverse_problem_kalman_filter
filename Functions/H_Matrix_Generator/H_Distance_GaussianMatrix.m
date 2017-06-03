function [ H ] = H_Distance_GaussianMatrix(faces, DistanceMatrix, N_Neighbors)
    
    global Patient_Condition;
    global GeometryModel;

    % load sigma
    
    load(['Data/' GeometryModel '/' Patient_Condition '/GaussParameters.mat'], 'sigma');
    load(['Data/' GeometryModel '/' Patient_Condition '/DistancesMetrics.mat']);

	% Calculate the size of the problem
	
	Nvertex = max(max(faces));
    MaxDistance = N_Neighbors*Dmean;
    
    H = zeros(Nvertex);
    
    for i = 1:1:Nvertex
        for j = i:1:Nvertex
            dij = DistanceMatrix(i,j);
            if dij < MaxDistance
                H(i,j) =  gaussmf(0, [sigma dij]);
            else
                H(i,j) = 0;
            end
            H(j,i) = H(i,j);
        end;
    end;
    H = NormalizedMatrix(H);
end