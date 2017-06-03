
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
% Parameters of execution for inverse problem.          %
% In this script is defined the parameters to           %
% execute the script in all scenaries . You have to put %
% all values in a vector where the first position is    %
% for the first execution , second position is for      %
% second execution and successively                     %
%                                                       %
% Implemented by    Juan Francisco Huete Verdejo        %
%                   January 2016                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Set parameters of the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % GeometryModel is the model where the signal is propragate. Can be
% % Espheric_Geometry or real geometry called Hearth_Geometry

% GeometryModel = 'Espheric_Geometry'

% % Patient condition is if the patient is Healthy or Sick

% Patient_Condition = 'Healthy'

% Nk is the numbers of instant that I want.
% Ik init k. Is the instant that I init the analisys

% % Single activation of the top of the sphere
% % -------------------------------------------
% Ik = 20;
% Nk = 86;

% All instant (this is very slow to calculate)
% ---------------------------------------------
% Ik = 1;
% Nk = T;

% Iks = [1,20,450,2913];
% Nks  = [86,258];
%
% % SNR of the problem (100 -> ideal; otherwise -> real)
% SNR_vs = [100,50,5];     % SNR of meassured equation in dB
%
% % Noise power
% var_ws = [0.1];                % Noise power of model
%
% % Transition Matrix H
%
% Hs(1) = struct('Type','Identity','H',H_Identity);
% Hs(2) = struct('Type','Neighbor','H',H_Neighbor);
% Hs(3) = struct('Type','Neighbor Gaussian','H',H_Gauss2);
%
% % Instant to plot in Geometric. Instant range in 0:Nks
% instant = [1,30,50,86];
% perspective = 'all';
%
% % Vertex
% vertexs=[1,5,20,300,1000];           % Vertex that you want to plot
%
% % Get and Save Video
% SaveVideo = true;
% perspective = 'all';  % Values: 'single','top','bottom','all'

% GeometryModel -> Espheric_Geometry; Hearth_Geometry
% GeometryModel = 'Espheric_Geometry';
global GeometryModel;
GeometryModel = 'Hearth_Geometry';

% Patient_Condition -> Healthy; Fibrillation1, Fibrillation2
global Patient_Condition;
Patient_Condition = 'Healthy';
% Patient_Condition = 'Fibrillation1';
% Patient_Condition = 'Fibrillation2';    % Only in Hearth_Geometry

Iks = [20];
Nks  = [86];

% SNR of the problem (100 -> ideal; otherwise -> real)
SNR_vs = [100];     % SNR of meassured equation in dB

% Noise power
var_ws = [0.1];     % Noise power of model

% Transition Matrix H
load(['./Matrix/' GeometryModel '/' Patient_Condition '/H_Matrix.mat']);

Hs(1) = struct('Type','Identity','H',H_Identity);
% Hs(2) = struct('Type','Adjancency','H',H_Adjancency);
% Hs(3) = struct('Type','Neighbor Gaussian step 2','H',H_GaussSteps2);
% Hs(4) = struct('Type','Neighbor Gaussian step 5','H',H_GaussSteps5);
% Hs(5) = struct('Type','Distance Gaussian 2 Neighbor','H',H_GaussDistance2);
% Hs(6) = struct('Type','Distance Gaussian 5 Neighbor','H',H_GaussDistance5);

% Instant to plot in Geometric. Instant range in 1:Nks
instants = [1,30,50,86];
perspective = 'all';        %Values 'single','top','bottom','all'

% Vertex
vertexs=[1,20,300,1000, 2000];           % Vertex that you want to plot

% Get and Save Video
SaveVideo = true;
VideoPerspective = 'all';   %Values 'single','top','bottom','all'
