function [ StepsMatrix ] = GetStepsMatrix(faces)

% This function obtain the matrix of steps of one vertex to any other
% vertex.
    
    try
        load('Temp/StepsNeighborMatrix.mat');
        loaded = true;
    catch
        loaded = false;
    end;
    
    if ~loaded
        % Calculate the size of the problem

        Nvertex = max(max(faces));

        fprintf('Generating Neighbor Matrix\n')
        NM = GetNeighborMatrix(faces);
        StepsMatrix = ones(Nvertex).*Inf;
        i=1;
    end;
    
    for i = i:1:Nvertex
        if ~loaded
            j = i;
        end;
        save 'Temp/StepsNeighborMatrix.mat' 'StepsMatrix' 'i' 'j' 'Nvertex' 'NM';
        for j = j:1:Nvertex
            if loaded
               loaded = false;
            end;
            fd = fopen('Temp/end.txt','r');
            [stop,~]=fscanf(fd,'%d');
            fclose(fd);
            if stop
                save 'Temp/StepsNeighborMatrix.mat' 'StepsMatrix' 'i' 'j' 'Nvertex' 'NM';
                return
            end;
            if StepsMatrix(i,j) == Inf
                fprintf('Vertex [%d,%d] of %d\n',i,j,Nvertex)
                if i == j
                    StepsMatrix(i,j)=1;
                else
                    if NM(i,j) ~= 1
                        Step = dijkstra(NM,i,j)+1;
                        if Step == Inf
                            Step = 0;
                        end;
                        StepsMatrix(i,j) = Step;
                    else
                        StepsMatrix(i,j) = 2;
                    end;
                end;
                StepsMatrix(j,i) = StepsMatrix(i,j);
            end;
        end;
    end;

    save 'Matrix/StepsNeighborMatrix.mat' 'StepsMatrix';
end