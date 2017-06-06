clear all; close all; clc;
execution = input('Enter execution name (None set the date): ','s');
disp('Adding to path all files...');
addpath(genpath('.'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters File
% parameters = 'full_problem';
parameters = 'basic_problem';
% parameters = 'develop';

if isempty(execution)
    execution = datestr(clock,30);
end;
root_path = ['Results/' parameters '_' execution];
mkdir(root_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Load parameters of the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading parameters of the problem...')

eval([parameters ';'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading data...');
data = ['./Data/' GeometryModel '/' Patient_Condition '/signal.mat'];
load(data);
disp('Loading geometries...');
data = ['./Data/' GeometryModel '/' Patient_Condition '/filled_geometry.mat'];
load(data);
% Transfer matrix
disp('Loading transfer matrix...');
load(['./Data/' GeometryModel '/' Patient_Condition '/transfer.mat']);
A = MTransfer;   % [MxN], transfer matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Definition of epicardial and torso data, and line time.
%
%   We have a torso potential phi_T and we want to estimate a epicardial
%   potential phi_E. But the problem is to calculate the transition matrix H
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ECG = MTransfer*EG;
phi_E_All = EG;    % [NxT], N # of nodes (vertex) in EPICARDIUM
phi_T_All = ECG;   % [MxT], M # of nodes (vertex) in TORSO
[N,t] = size(phi_E_All);
[M,~] = size(phi_T_All);
T = linspace(1,t,t);            % [Tx1], T # of time instants

scenary = 0;

for Nk = Nks
    for var_w = var_ws
        for SNR_v = SNR_vs
            for Ik = Iks
                scenary = scenary+1;
                for H_struct = Hs
                    NewToc = toc;
                    HType = H_struct.Type;
                    path = [root_path '/STM_' HType '/Scenary' num2str(scenary)];
                    mkdir(path);
                    mkdir(path,'data');
                    mkdir(path,'figures');
                    mkdir(path,'GeometricFigures');
                    mkdir(path,'images');
                    mkdir(path,'GeometricImages');
                    mkdir(path,'videos');
                    fd = fopen(strcat(path,'/INFO.txt'),'w');
                    addpath(genpath('Results'));
                    if Ik+Nk-1 > max(T)
                        disp('The number of instant exceed the limit')
                        Nk = max(T)-Ik+1;
                        Nks = Nk;
                        fprintf(strcat('The number of instant it set',...
                                       'to max permitied. Nk=%i',Nk));
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Start to resolve inverse problem
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    SolutionOfInverseProblem;
                     
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Sava Data
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    SaveData;
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Plot and save results
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    % Save 3D Plots
                    for instant = instants
                        close all;
                        PlotInGeometry;
                    end;
                    
                    % Save Video
                    SaveGeometricVideoResult;
                    
                    % Save Plots for one node
                    for vertex = vertexs
                        PlotOneVertex;
                    end;
                end;
            end;
        end;
    end;
end;

% Compare results
ResultComparation;

fclose('all');
close all;

fprintf('\nTotal Execution time = %i\n',toc);
