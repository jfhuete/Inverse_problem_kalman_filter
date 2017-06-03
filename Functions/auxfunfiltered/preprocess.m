function [x,y,Cn,A] = preprocess (x, MTransfer, model, SNR, fs, f_low, f_high)
% Filtering epicarcial potentials, applying WCT correction and compute forward problem.
%
% This function by Víctor Suárez Gutiérrez (victor.suarez.gutierrez@urjc.es)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT: 
% x: epicardial potentials [NxT]
% Mtransfer: transfer matrix.
% model: place where rotor occurs {'SR', 'SAF', 'CAF'}
% SNR: Signal to Noise Ratio.
% fs: sampling frecuency.
% f_low: low cut-off frecuency (default= 11 Hz).
% f_high: high cut-off frecuency (default= 13 Hz).
%
%OUTPUT:
% x: filtered epicardial potentials.
% y: filtered and noisy (SNR) torso potentials.
% Cn: noise covariance matrix.
% A: transfer matrix with WCT correction.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Transform transfer matrix to account for WCT correction
A_original = MTransfer;   % [MxN]; transfer matrix.
[n_torso, n_epi] = size(A_original);
wct = 1/3;
wct_nodes = [192,580,588];
A_wct = zeros(n_torso);    % [MXM]
A_wct(:,wct_nodes) = wct;
A = (A_original - A_wct*A_original);    %A_wct


%% Bipolar reference
x = bsxfun(@minus,x,mean(x,2));  % Remove mean
x_uni = preprocessFA (x, fs, f_low, f_high, model);
y = A*x_uni;    % [MxT]; M: numbers of nodes (triangles´ vertexs) in torso.

% Bipolar epicarcial potentials:
x_c = x_uni-repmat(mean(y(wct_nodes,:)),length(x_uni(:,1)),1);    % epicardial potentials referenced to wct.

% Bipolar torso potentials:
A_wct_e = zeros(n_epi,n_torso);   % [NXM]
A_wct_e(:,wct_nodes) = wct;
y_c = (A/(eye(length(A(1,:)))-A_wct_e*A_original))*x_c;


%% Assigning variable names
x = x_c;    % [NxT]; N: numbers of nodes (triangles´ vertexs) in epicardium. 
y = y_c;    % [MxT]; M: numbers of nodes (triangles´ vertexs) in torso.


%% Forward problem
[y, Cn] = filtering (y, SNR, fs, model, f_low, f_high);






