%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Save Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save([path '/data/phi_E_est.mat'],'phi_E_est');
save([path '/data/HQuality.mat'],'HQ');
save([path '/data/error_meassured.mat'],'corr_mean','RMSE_mean');
save([path '/data/noise.mat'],'SNR_v', 'var_w');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save Parameter to Info file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fd,'Ik = %i',Ik);
fprintf(fd,'\nNk = %i',Nk);
fprintf(fd,'\nSNR_v = %i',SNR_v);
fprintf(fd,'\nvar_w = %i',var_w);
fprintf(fd,['\nH = ' HType]);
fprintf(fd,'\nExecution time = %i',toc-NewToc);
fprintf(fd,'\n***************************');
fprintf(fd,'\n RESULT: ');
fprintf(fd,'\n***************************');
fprintf(fd,'\nCorrelation Mean: = %i',corr_mean);
fprintf(fd,'\nRMSE Mean: = %i',RMSE_mean);
fclose(fd);

fprintf('\n***************************');
fprintf('\nIk = %i',Ik);
fprintf('\nNk = %i',Nk);
fprintf('\nSNR_v = %i',SNR_v);
fprintf('\nvar_w = %i',var_w);
fprintf(['\nH = ' HType]);
fprintf('\nExecution time = %i',toc-NewToc);
fprintf('\n***************************\n');
fprintf('\n RESULT: ');
fprintf('\n***************************');
fprintf('\nCorrelation Mean: = %i',corr_mean);
fprintf('\nRMSE Mean: = %i\n',RMSE_mean);
