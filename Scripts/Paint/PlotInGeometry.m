%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot result in geometry model for one instant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if instant > Nk
    fprintf(['\nInstant exceed the max number '...
             'of instanst. Instant is change '...
             'to Nk value\n']);
    instant = Nk;
end;
[~,GeoFig] = DrawInGeometric(atrial_model,torso_model,phi_E_est,phi_T,...
             instant,perspective,'Osignal',phi_E,...
             'Hquality',HQ);

SaveGeometricFigureResult;
