clear all;

global Patient_Condition;
global GeometryModel;
GeometryModel = 'Hearth_Geometry';
Patient_Condition = 'Fibrillation2';

load(['.\Data\' GeometryModel '\' Patient_Condition '\GaussParameters.mat']);
load(['.\Data\' GeometryModel '\' Patient_Condition '\filled_geometry.mat']);
load(['.\Matrix\' GeometryModel '\NeighborMatrix.mat']);
load(['.\Matrix\' GeometryModel '\StepsNeighborMatrix.mat']);
load(['.\Matrix\' GeometryModel '\EuclideanDistancesMatrix.mat'])

[H_size, ~] = size(NeighborMatrix);

H_Identity = eye(H_size);
H_Adjancency = NormalizedMatrix(NeighborMatrix);
H_GaussSteps2 = H_Steps_GaussianMatrix(atrial_model.faces, StepsNeighborMatrix, 2, sigma);
H_GaussSteps5 = H_Steps_GaussianMatrix(atrial_model.faces, StepsNeighborMatrix, 5, sigma);
H_GaussDistance2 = H_Distance_GaussianMatrix(atrial_model.faces, DistanceMatrix, 2);
H_GaussDistance5 = H_Distance_GaussianMatrix(atrial_model.faces, DistanceMatrix, 5);

save(['./Matrix/' GeometryModel '/' Patient_Condition '/H_Matrix.mat'], 'H_Identity', 'H_Adjancency', 'H_GaussSteps2', 'H_GaussSteps5', 'H_GaussDistance2', 'H_GaussDistance5');