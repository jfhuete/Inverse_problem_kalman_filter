%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get and Save Video for All instans if is Enabled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if SaveVideo
   vw = VideoWriter([path '/videos/video.avi']);
   vw.FrameRate = 45;
   vw.Quality = 100;
   video = VideoInGeometric(vw,atrial_model,torso_model,phi_E_est,phi_T,...
           VideoPerspective,'Osignal',phi_E,...
           'Hquality',HQ);
end

close all;