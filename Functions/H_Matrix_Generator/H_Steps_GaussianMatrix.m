function [ H ] = H_Steps_GaussianMatrix(faces, StepsMatrix, N_Neighbors, sigma)
 
    % Calculate the size of the problem
	
	Nvertex = max(max(faces));
    HDim = N_Neighbors+1;
    
	% Set gaussian coeficient dimension
	
	if mod(HDim,2) == 0
		HDim = HDim+1;
	end

	% Get Gaussian filter matrix
    fprintf('Generating Gaussian Matrix\n')
	Hfilter=fspecial('gaussian',[HDim,HDim],sigma);

	% Create coeficients vector

	coef = [];
    fprintf('Obtainig gaussian coeficient\n')
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
                try
                    H(i,j) = coef(c);
                catch ME
                    if strcmp(ME.identifier, 'MATLAB:badsubscript')
                       H(i,j) = coef(end); 
                    end
                end
            end
            H(j,i) = H(i,j);
        end;
    end;
    H = NormalizedMatrix(H);
end