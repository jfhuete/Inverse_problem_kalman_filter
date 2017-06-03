%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Plot results in one figure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H_matrix_dir = dir(root_path);
[N_matrix_dir, ~] = size(H_matrix_dir);
mkdir([root_path '/results']);
for j = 1:1:scenary
    scenary_path = ['Scenary' num2str(j)];
    N_serie = 1;
    results_phi_E(1,:,:) = phi_E;
    results_HQ(1,:,:) = zeros(N,Nk);
    Legends_names = 'Real phi E';
    Matrix_names = 'Real phi E';
    mkdir([root_path '/results/' scenary_path]);
    mkdir([root_path '/results/' scenary_path '/images']);
    mkdir([root_path '/results/' scenary_path '/figures']);
    mkdir([root_path '/results/' scenary_path '/geometricFig']);
    mkdir([root_path '/results/' scenary_path '/geometricImg']);
    for i = 1:1:N_matrix_dir
        H_matrix_name = H_matrix_dir(i).name;
        if strcmp(H_matrix_name, '.') == 0 && strcmp(H_matrix_name, '..') == 0 && strcmp(H_matrix_name, 'results') == 0
            data_path = [root_path '/' H_matrix_name '/' scenary_path '/data/'];
            load([data_path 'phi_E_est.mat']);
            load([data_path 'error_meassured.mat']);
            load([data_path 'HQuality.mat']);
            load([data_path 'noise.mat']);
            Matrix_names = strvcat(Matrix_names, strrep(H_matrix_name, '_',' '));
            Legends_names = strvcat(Legends_names,[strrep(H_matrix_name, '_',' ')...
                                                   sprintf('\n    * MRSE mean: ') num2str(RMSE_mean)...
                                                   sprintf('\n    * CORR mean: ') num2str(corr_mean)]);
            Parameters_Texts = strvcat(strvcat(num2str(j),num2str(SNR_v)),num2str(var_w));
            % Save phi_E_est in array
            N_serie = N_serie+1;
            results_phi_E(N_serie,:,:) = phi_E_est;
            results_HQ(N_serie,:,:) = HQ;
        end
    end
    for node = vertexs
       phi_E_fig =  PlotResults(samples, results_phi_E, node, 'Phi E estimated comparation', 'Epicardial Potential (mV)', Legends_names, Parameters_Texts);
       quality_fig = PlotResults(samples, results_HQ, node, 'H Quality','Quality. 0 is the best', Legends_names, Parameters_Texts);
       saveas(phi_E_fig,[root_path '/results/' scenary_path '/figures/PhiEComparation_v' num2str(node) '.fig'], 'fig');
       saveas(quality_fig,[root_path '/results/' scenary_path '/figures/HQualityComparation_v' num2str(node) '.fig'], 'fig');
       saveas(phi_E_fig,[root_path '/results/' scenary_path '/images/PhiEComparation_v' num2str(node) '.jpg']);
       saveas(quality_fig,[root_path '/results/' scenary_path '/images/HQualityComparation_v' num2str(node) '.jpg']);
    end
    close all;
    for instant = instants
        geometric_fig = PlotResultsInGeometric(atrial_model, instant, results_phi_E, 'Phi E estimated comparation', Matrix_names, Parameters_Texts);
        saveas(geometric_fig,[root_path '/results/' scenary_path '/geometricFig/PhiEComparation_t' num2str(instant) '.fig'], 'fig');
        saveas(geometric_fig,[root_path '/results/' scenary_path '/geometricImg/PhiEComparation_t' num2str(instant) '.jpg']);
    end
    close all;
    if SaveVideo
        mkdir([root_path '/results/' scenary_path '/video']);
        vw = VideoWriter([root_path '/results/' scenary_path '/video/result.avi']);
        vw.FrameRate = 45;
        vw.Quality = 100;
        VideoResultInGeometric(vw, atrial_model, results_phi_E, samples, 'Phi E estimated comparation', Matrix_names, Parameters_Texts);
    end
    clear Matrix_names;
    clear Legends_names;
    clear Parameters_Texts;
    clear results_phi_E;
    clear results_HQ;
end