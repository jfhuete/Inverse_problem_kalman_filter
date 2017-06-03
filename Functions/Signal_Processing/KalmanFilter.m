function [ signal_est ] = KalmanFilter( signal_measured, Nk, Ik, H, A, MENP, MONP)
    
    % This function applied a kalman filter to the input signal
    
    % signal_measured: Signal measured by the sensor (Real signal)
    % Nk: Number of instants
    % Ik: Initial instant
    % H: Transition matrix
    % A: Transfer matrix
    % MENP: Measured noise power
    % MONP: Model noise power


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Kalman filter
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp('Start Kalman Filter')
    % signal_est_b = signal estimated in before time instant
    % signal_est_a = signal estimated in actual time
    % signal_est   = signal estimated
    
    % Dimension of estimated signal
    
    [M,N] = size(A);
    
    % Noise covariance matrix of meassured
    R = eye(M)*MENP;

    % Noise covariance matrix of model
    Q = eye(N)*MONP;
    
    % Covariance of error matrix

    P = zeros(N,N);
    % pk = zeros(N,N,Nk); % <=== Mirar como se representa (Muy grande fallo de memoria)
    
    % Inicialize the variables to 0

    signal_est_b = zeros(N,1);
    signal_est_a = zeros(N,1);
    signal_est   = zeros(N,Nk);
    fprintf('\n');
    c = 0;
    for k=1:Nk
        for rm = 1:1:c
            fprintf('\b');
        end;
        c = fprintf('Time instant: %d/%d',k+Ik-1,(Nk+Ik-1));

        % Predict step
        % ------------------------------

        signal_est_a = H*signal_est_b;    % predicted next state
        P = H*P*H' + Q;                 % predicted estimated covariance

        % Update step
        % ------------------------------

        K = (P*A')/(A*P*A'+R);       % optimal Kalman gain
        signal_est_a = signal_est_a + K*(signal_measured(:,k)-A*signal_est_a); %Update estimated
        P = (eye(size(signal_est_a,1))-K*A)*P;    % Update estimated covariance

        % Set result in the final epicardial potetial matrix estimated

        signal_est(:,k)=signal_est_a;

        % Save error covariance matrix for actual instant

        % pk(:,:,k)=P;  % <=== mirar como se representa

        % Go to next step signal_est_a is now signal_est_b

        signal_est_b=signal_est_a;

    end
end

