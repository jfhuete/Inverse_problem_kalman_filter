%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimice solution only for obtain best sigma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

addpath(genpath('.'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Variables to find max correlation and min RMSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_corr_mean = -inf;
max_corr_mean_RMSE_mean_associated = 0;
corr_best_sigma = 0;
min_RMSE_mean = inf;
min_RMSE_mean_corr_mean_associated = 0;
RMSE_best_sigma = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters File
parameters = 'basic_problem';

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Hs Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(['./Matrix/' GeometryModel '/StepsNeighborMatrix.mat']);

Ik = 20;
Nk = 86;

clear Hs;

Nsigmas = 25;

[Hs, sigmas] = H_Steps_GaussianMatrix_Sigma_Scaning(atrial_model.faces, StepsNeighborMatrix, 3, Nsigmas);

scenary = 0;

mkdir('./Results','best_sigma');

for var_w = var_ws
    for SNR_v = SNR_vs
        scenary = scenary + 1;
        mkdir('./Results/best_sigma',['Scenary' num2str(scenary)]);
        for Nsigma = 1:1:Nsigmas
            H = squeeze(Hs(Nsigma,:,:));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % load and dimensioned of variables of the problem
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % samples is a interval of instant
            samples = Ik:(Nk+Ik-1);

            % Decresae problem
            phi_E = phi_E_All(:,samples);
            phi_T = phi_T_All(:,samples);

            % Noise power
            var_v = mean(var(phi_T))/(10^(SNR_v/10)); % Noise power of meassures
            phi_T_n = addwhitenoise(phi_T,SNR_v);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   Quality of Transition Matrix
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            HQ = phi_E(:,2:end)-H*phi_E(:,1:end-1); % 0 is the best

            % Regulate dimesion

            HQ(:,Nk) = 0;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   Kalman filter
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            phi_E_est = KalmanFilter(phi_T_n,Nk,Ik,H,A,var_v,var_w);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Error Metric
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



            correlations = zeros(1,N);
            MSE = zeros(1,N);

            for node = 1:1:N
                % Correlation meassure
                corr_aux = corrcoef(phi_E(node,:),phi_E_est(node,:));
                correlations(node) = corr_aux(1,2);

                % Mean square error
                RMSE(node) = sqrt(mean((phi_E(node,:)-phi_E_est(node,:)).^2));
            end;

            clear corr_aux;

            corr_mean = mean(correlations);
            RMSE_mean = mean(RMSE);
            
            if corr_mean > max_corr_mean
                max_corr_mean = corr_mean;
                max_corr_mean_RMSE_mean_associated = RMSE_mean;
                corr_best_sigma = sigmas(Nsigma);
            end
            
            if RMSE_mean < min_RMSE_mean
                min_RMSE_mean = RMSE_mean;
                min_RMSE_mean_corr_mean_associated = corr_mean;
                RMSE_best_sigma = sigmas(Nsigma);
            end            
        end
        if RMSE_best_sigma ~= corr_best_sigma
            diff_RMSE = abs(max_corr_mean_RMSE_mean_associated-min_RMSE_mean);
            diff_corr = abs(max_corr_mean-min_RMSE_mean_corr_mean_associated);
            if diff_RMSE > diff_corr
               sigma =  RMSE_best_sigma;
               selected_sigma = 'RMSE';
            else
               sigma =  corr_best_sigma;
               selected_sigma = 'corr';
            end
        else
            sigma = corr_best_sigma;
            selected_sigma = 'equal';
        end
        save(['./Results/best_sigma/Scenary' num2str(scenary) '/best_sigma_by_corr.mat'],'max_corr_mean','max_corr_mean_RMSE_mean_associated','corr_best_sigma','var_w', 'SNR_v');
        save(['./Results/best_sigma/Scenary' num2str(scenary) '/best_sigma_by_RMSE.mat'],'min_RMSE_mean','min_RMSE_mean_corr_mean_associated','RMSE_best_sigma','var_w', 'SNR_v');
        save(['./Data/' GeometryModel '/' Patient_Condition '/GaussParameters.mat'],'sigma','selected_sigma')
    end
end
