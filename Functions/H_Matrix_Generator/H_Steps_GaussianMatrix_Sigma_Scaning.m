function [ H, sigmas ] = H_Steps_GaussianMatrix_Sigma_Scaning(faces, StepsMatrix, N_Neighbors, Nsigmas)

% function generate a H matrix for diferent sigma since dmin/2 to dmax.

global GeometryModel;
global Patient_Condition;
% loading metrics of distances of nodes
load(['Data/' GeometryModel '/' Patient_Condition '/DistancesMetrics.mat']);

sigmas = linspace(Dmin/2, Dmax, Nsigmas);

for i = 1:1:Nsigmas
   H(i,:,:) = H_Steps_GaussianMatrix(faces, StepsMatrix, N_Neighbors, sigmas(i));
end

