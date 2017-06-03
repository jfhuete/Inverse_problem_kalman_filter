function [fig] = PlotResultsInGeometric(model, t, results, plot_title, Matrix_names, Parameters_Text)
    % Screen size to centrate plots
    screen_size = get( groot, 'Screensize' );
    width  = screen_size(3);
    height = screen_size(4);
    xpos = (width-1200)/2;
    ypos = (height-768)/2;

    fig = gcf;
    title(plot_title)
    set(gcf,'Color','White','Position',[xpos ypos 1200 768]);
    clf;
    
    [Nplot, ~, ~] = size(results);
    
    faces    = model.faces;
    vertices = model.vertices;
    
    maxCAXIS=max(max(max(results))); % Green V=0
    
    for i = 1:1:Nplot
        
        % Plot top view
        
        subplot(3,Nplot+1,i);
        
        caxis(maxCAXIS.*[-1 1]);
        aux = patch('Faces', faces,...
        'Vertices', vertices,...
        'FaceVertexCData',results(i,:,t)');

        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        view(0,90);
        camlight('infinite');
        if i <= Nplot
            title(StringInLines(strtrim(Matrix_names(i,:)),25));
        end
        
        if i == Nplot
            subplot(3,Nplot+1,Nplot+1);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end
        
        % plot middle view
        
        subplot(3,Nplot+1,Nplot+1+i);
        
        caxis(maxCAXIS.*[-1 1]);
        aux = patch('Faces', faces,...
        'Vertices', vertices,...
        'FaceVertexCData',results(i,:,t)');

        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        view(0,0);
        camlight('infinite');
        if i <= Nplot
            title(StringInLines(strtrim(Matrix_names(i,:)),25));
        end
        
        if i == Nplot
            subplot(3,Nplot+1,Nplot+2+i);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end
        
         % plot middle view
        
        subplot(3,Nplot+1,(Nplot+1)*2+i);
        
        caxis(maxCAXIS.*[-1 1]);
        aux = patch('Faces', faces,...
        'Vertices', vertices,...
        'FaceVertexCData',results(i,:,t)');

        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        view(0,-90);
        camlight('infinite');
        if i <= Nplot
            title(StringInLines(strtrim(Matrix_names(i,:)),25));
        end
        
        if i == Nplot
            subplot(3,Nplot+1,(Nplot+1)*2+i+1);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end

    end
    
end

