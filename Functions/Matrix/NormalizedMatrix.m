function [ H ] = NormalizedMatrix( H )

    % Normaliced the Neighbor matrix
    fprintf('Transform to stochastic matrix\n')
    SumH = sum(H);
    SumH = SumH';
    [dim,~] = size(H);
    for f = 1:1:dim
        for c = 1:1:dim
            H(f,c) = H(f,c)/SumH(f);
        end;
    end;

end

