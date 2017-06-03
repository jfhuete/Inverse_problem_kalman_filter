function [aux,fig] = DrawInGeometric(hearth_model,torso_model, signal,torso_signal,t,varargin)
    
    global GeometryModel;

    p = inputParser;
    expectedPerspectives = {'single','top','bottom','all'};
    
    addRequired(p,'hearth_model');
    addRequired(p,'torso_model');
    addRequired(p,'signal');
    addRequired(p,'torso_signal');
    addRequired(p,'t');
    addOptional(p,'perspectives','single',@(x)...
                   any(validatestring(x,expectedPerspectives)))
    addParameter(p,'Esignal',0);
    addParameter(p,'Osignal',0);
    addParameter(p,'Hquality',0);
    parse(p,hearth_model,torso_model,signal,torso_signal,t,varargin{:});
    
    Esignal = p.Results.Esignal;
    Osignal = p.Results.Osignal;
    HQ = p.Results.Hquality;
    
    perspective = p.Results.perspectives;
    
    Nplot = 1;
    Aplot = 1;
    
    % Configure figure position
    screen_size = get( groot, 'Screensize' );
    width  = screen_size(3);
    height = screen_size(4);
    xpos = (width-1024)/2;
    ypos = (height-768)/2;
    
    
    fig = gcf;
    set(gcf,'Color','White','Position',[xpos ypos 1024 768]);
    clf;
    
    switch perspective
        case 'single'
            Fplot = 1;
        case 'top'
            Fplot = 2;
        case 'bottom'
            Fplot = 2;
        otherwise
            Fplot = 3;
    end
    
    if Esignal ~= 0
        Nplot = Nplot + 1;
    end

    if Osignal ~= 0
        Nplot = Nplot + 1;
    end
    
    if size(HQ) ~= [1 1]
        Nplot = Nplot + 1;
    end
    
    hearth_faces    = hearth_model.faces;
    hearth_vertices = hearth_model.vertices;

    maxCAXIS=max(max(abs( signal(:,1:end) ))); % Green V=0
    
    if Osignal ~= 0
        for fp = 1:1:Fplot
            Aplot = Aplot + (Nplot+1)*(fp-1);
            subplot(Fplot,Nplot+1,Aplot);
            caxis(maxCAXIS.*[-1 1]);
            aux = patch('Faces', hearth_faces,...
            'Vertices', hearth_vertices,...
            'FaceVertexCData', Osignal(:,t));

            axis equal;
            shading faceted;
            axis off

            %%% Iluminacion
            lighting phong
            material([0.3 0.4 0.3])
            shading interp;
            
            if strcmp(GeometryModel, 'Hearth_Geometry')
                view(-10,40);
                if fp == 2
                    zoom(1.5);
                end
            else
                view(0,0);
            end
            
            camlight('infinite')

            title(['Original signal t=' num2str(t)])
            Aplot = Aplot - (Nplot+1)*(fp-1);
            if Aplot == Nplot
                Aplot = Aplot + (Nplot+1)*(fp-1);
                subplot(Fplot,Nplot+1,Aplot+1);
                colorbar
                axis off
                caxis(maxCAXIS.*[-1 1]);
                Aplot = Aplot - (Nplot+1)*(fp-1);
            end
        end
        Aplot = Aplot +1;
    end
    for fp = 1:1:Fplot
        Aplot = Aplot + (Nplot+1)*(fp-1);
        subplot(Fplot,Nplot+1,Aplot);

        aux = patch('Faces', hearth_faces,...
            'Vertices', hearth_vertices,...
            'FaceVertexCData', signal(:,t));

        caxis(maxCAXIS.*[-1 1]);
        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong
        material([0.3 0.4 0.3])
        shading interp;
         if strcmp(GeometryModel, 'Hearth_Geometry')
            view(-10,40);
            if fp == 2
                zoom(1.5);
            end
        else
            view(0,0);
        end
        camlight('infinite')

        title(['Estimate signal t=' num2str(t)])
        Aplot = Aplot - (Nplot+1)*(fp-1);
        if Aplot == Nplot
            Aplot = Aplot + (Nplot+1)*(fp-1);
            subplot(Fplot,Nplot+1,Aplot+1);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
            Aplot = Aplot - (Nplot+1)*(fp-1);
        end
    end

    Aplot = Aplot +1;
    
    if Esignal ~= 0
        for fp = 1:1:Fplot
            Aplot = Aplot + (Nplot+1)*(fp-1);
            subplot(Fplot,Nplot+1,Aplot);
            caxis(maxCAXIS.*[-1 1]);
            aux = patch('Faces', hearth_faces,...
            'Vertices', hearth_vertices,...
            'FaceVertexCData', Esignal(:,t));

            axis equal;
            shading faceted;
            axis off

            %%% Iluminacion
            lighting phong
            material([0.3 0.4 0.3])
            shading interp;
            if strcmp(GeometryModel, 'Hearth_Geometry')
                view(-10,40);
                if fp == 2
                    zoom(1.5);
                end
            else
                view(0,0);
            end
            camlight('infinite')

            title(['Correlation t=' num2str(t)])
            Aplot = Aplot - (Nplot+1)*(fp-1);
            if Aplot == Nplot
                Aplot = Aplot + (Nplot+1)*(fp-1);
                subplot(Fplot,Nplot+1,Aplot+1);
                colorbar
                axis off
                caxis(maxCAXIS.*[-1 1]);
                Aplot = Aplot - (Nplot+1)*(fp-1);
            end
        end
        Aplot = Aplot +1;
    end
    
    if size(HQ) ~= [1 1]
        for fp = 1:1:Fplot
            Aplot = Aplot + (Nplot+1)*(fp-1);
            subplot(Fplot,Nplot+1,Aplot);
            caxis(maxCAXIS.*[-1 1]);
            aux = patch('Faces', hearth_faces,...
            'Vertices', hearth_vertices,...
            'FaceVertexCData', HQ(:,t));

            axis equal;
            shading faceted;
            axis off

            %%% Iluminacion
            lighting phong
            material([0.3 0.4 0.3])
            shading interp;         
            if strcmp(GeometryModel, 'Hearth_Geometry')
                view(-10,40);
                if fp == 2
                    zoom(1.5);
                end
            else
                view(0,0);
            end
            camlight('infinite')

            title(['H Quality t=' num2str(t)])
            Aplot = Aplot - (Nplot+1)*(fp-1);
            if Aplot == Nplot
                Aplot = Aplot + (Nplot+1)*(fp-1);
                subplot(Fplot,Nplot+1,Aplot+1);
                colorbar
                axis off
                caxis(maxCAXIS.*[-1 1]);
                Aplot = Aplot - (Nplot+1)*(fp-1);
            end
        end
    end
    
    switch perspective
        case 'all'
            for n = 1:Nplot
                subplot(Fplot,Nplot+1,n);
                if strcmp(GeometryModel, 'Hearth_Geometry')
                    view(-90, -10);
                else
                    view(0,90);
                end
                axis equal;
            end
            for n = 1:Nplot
                subplot(Fplot,Nplot+1,n+(Nplot+1)*2);
                if strcmp(GeometryModel, 'Hearth_Geometry')
                    view(60, -90);
                    zoom(1.3);
                else
                    view(0,-90);
                end
                axis equal;
            end
        case 'top'
            for n = 1:Nplot
                subplot(Fplot,Nplot+1,n);
                if strcmp(GeometryModel, 'Hearth_Geometry')
                    view(-90, -10);
                else
                    view(0,90);
                end
                axis equal;
            end
        case 'bottom'
            for n = 1:Nplot
                subplot(Fplot,Nplot+1,n+(Nplot+1)*2);
                if strcmp(GeometryModel, 'Hearth_Geometry')
                    view(60, -90);
                    zoom(1.3);
                else
                    view(0,-90);
                end
                axis equal;
            end
    end
end
