function [video] = VideoInGeometric(vw,hearth_model,torso_model, signal,torso_signal, varargin)
	
    p = inputParser;
    expectedPerspectives = {'single','top','bottom','all'};
    
    addRequired(p,'hearth_model');
    addRequired(p,'signal');
    addOptional(p,'perspectives','single',@(x)...
                   any(validatestring(x,expectedPerspectives)))
    addParameter(p,'Esignal',0);
    addParameter(p,'Osignal',0);
    addParameter(p,'Hquality',0);
    parse(p,hearth_model,signal,varargin{:});
    
    Esignal = p.Results.Esignal;
    Osignal = p.Results.Osignal;
    HQ = p.Results.Hquality;
    
    if Esignal ~= 0
        [~,instant] = size(signal);
        Esignal = Esignal(:,1:instant);
    end;
    
    perspective = p.Results.perspectives;
    
    [~,samples] = size(signal);
    
    open(vw);
    
    DrawInGeometric(hearth_model,torso_model, signal, torso_signal, 1,perspective,'Osignal',...
                          Osignal,'Esignal',Esignal,'Hquality',HQ);
    pause(5)
    for t = 1:1:samples
        aux=DrawInGeometric(hearth_model,torso_model, signal, torso_signal, t,perspective,'Osignal',...
                             Osignal,'Esignal',Esignal,'Hquality',HQ);
        drawnow;
        video(t)=getframe(gcf);
        if t ~= samples(end)
            delete(aux);
            clf;
        end;
    end
    writeVideo(vw,video);
    close(vw);
end

