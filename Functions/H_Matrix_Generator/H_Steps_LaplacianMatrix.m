function [ H ] = H_Steps_LaplacianMatrix(faces, StepsMatrix)
    
	% Calculate the size of the problem
	N_Neighbors = 2;
	Nvertex = max(max(faces));

	% Get Gaussian filter matrix
    fprintf('Generating laplacian Matrix\n')
	Hfilter=fspecial('laplacian');

	% Create coeficients vector

	coef = [];
    fprintf('Obtainig laplacian coeficient\n')
	while max(max(Hfilter)) ~= 0
		coef = [coef,max(max(Hfilter))];
		[i,j] = find(Hfilter==max(max(Hfilter)));
        [NCoef,~] = size(i);
        for k = 1:1:NCoef
            Hfilter(i(k),j(k))=0;
        end;
    end;
    
    for i = 1:1:Nvertex
        for j = i:1:Nvertex
            c = StepsMatrix(i,j);
            if c == 0 || c > N_Neighbors
                H(i,j) = 0;
            else
                H(i,j) = coef(c);
            end
            H(j,i) = H(i,j);
        end;
    end;
    H = NormalizedMatrix(H);
end