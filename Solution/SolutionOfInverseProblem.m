%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
% Solution of inverse problem optimiced                                      %
% with a kalman filter                                                       %
%                                                                            %
% Implemented by    Juan Francisco Huete Verdejo                             %
%                   October 2016                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load and dimensioned of variables of the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% samples is a interval of instant
samples = Ik:(Nk+Ik-1);

% Decresae problem
phi_E = phi_E_All(:,samples);
phi_T = phi_T_All(:,samples);

% Transition matrix
H = H_struct.H;

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
