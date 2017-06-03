function [DistanceMatrix] = GetEuclideanDistancesMatrix(faces)

% This function obtain the matrix of distances of one vertex to any other
% vertex. Is similar to GetStepsMatrix but with Euclidean distances
% instead of step distances.

    try
        load('Temp/EuclideanDistancesMatrix.mat');
        loaded = true;
    catch
        loaded = false;
    end;
    
    if ~loaded
        % Calculate the size of the problem

        Nvertex = max(max(faces));

        fprintf('Load Euclidean Neighbor Matrix\n')
        load('Matrix/EuclideanNeighborMatrix.mat');
        NM = EuclideanNeighborMatrix;
        DistanceMatrix = ones(Nvertex).*Inf;
        i=1;
    end;
    
    for i = i:1:Nvertex
        if ~loaded
            j = i;
        end;
        save 'Temp/EuclideanDistancesMatrix.mat' 'DistanceMatrix' 'i' 'j' 'Nvertex' 'NM';
        for j = j:1:Nvertex
            if loaded
               loaded = false;
            end;
            fd = fopen('Temp/end.txt','r');
            [stop,~]=fscanf(fd,'%d');
            fclose(fd);
            if stop
                save 'Temp/EuclideanDistancesMatrix.mat' 'DistanceMatrix' 'i' 'j' 'Nvertex' 'NM';
                return
            end;
            if DistanceMatrix(i,j) == Inf
                fprintf('Vertex [%d,%d] of %d\n',i,j,Nvertex)
                if i == j
                    DistanceMatrix(i,j)=0;
                else
                    if NM(i,j) == 0
                        Distance = dijkstra(NM,i,j);
%                         if Distance == Inf
%                             Distance = 0;
%                         end;
                        DistanceMatrix(i,j) = Distance;
                    else
                        DistanceMatrix(i,j) = NM(i, j);
                    end;
                end;
                DistanceMatrix(j,i) = DistanceMatrix(i,j);
            end;
        end;
    end;

    save 'Matrix/EuclideanDistancesMatrix.mat' 'DistanceMatrix';
end