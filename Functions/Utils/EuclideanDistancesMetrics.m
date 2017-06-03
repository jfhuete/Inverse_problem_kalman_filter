function [ Dmin, Dmax, Dmean ] = EuclideanDistancesMetrics(EuclideanDistancesMatrix)
% This function return the min and max distance between nodes, and the mean
% of the distances between nodes.

[N, ~] = size(EuclideanDistancesMatrix);

Dmin = inf;
Dmax = 0;
Dmean = 0;

counter = 0;

for i = 1:1:N
    for j = 1:1:N
        value = EuclideanDistancesMatrix(i, j);
        if value ~= 0
            % Check if value is min
            if value < Dmin
                Dmin = value;
            end
            
            % Check if value is max
            if value > Dmax
                Dmax = value;
            end
            
            Dmean = Dmean +value;
            counter = counter + 1;
        end
    end
end

Dmean = Dmean/counter;

end

