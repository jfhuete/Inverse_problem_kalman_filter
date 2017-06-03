function [ NeighborMatrix ] = GetNeighborMatrix( faces )

	%   This function obtain the neighbors of one point form the faces GetNeighborMatrix

	[Nfaces,~] = size(faces);
	Nvertex = max(max(faces));

	NeighborMatrix = eye(Nvertex);

    for f = 1:1:Nfaces
        fprintf('Analizing face %d of %d\n',f,Nfaces)
		pv = faces(f,1:3);
		v = pv(1);
		nv = pv(2);
        NeighborMatrix(v,nv) = 1;
		NeighborMatrix(nv,v) = 1;
		nv = pv(3);
		NeighborMatrix(v,nv) = 1;
		NeighborMatrix(nv,v) = 1;
		v = pv(2);
		nv = pv(3);
		NeighborMatrix(v,nv) = 1;
		NeighborMatrix(nv,v) = 1;
    end;
end
