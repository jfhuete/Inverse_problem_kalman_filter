function [fig] = PlotResultsInGeometric(model, torso_model, t, results, torso_signal, plot_title, Matrix_names, Parameters_Text)

    global GeometryModel;
    % Screen size to centrate plots
    screen_size = get( groot, 'Screensize' );
    width  = screen_size(3);
    height = screen_size(4);
    xpos = (width-1200)/2;
    ypos = (height-768)/2;

    fig = gcf;
    title(plot_title)
    set(gcf,'Color','White','Position',[xpos ypos 1366 768]);
    clf;
    
    [Nplot, ~, ~] = size(results);
    Nplot = Nplot+1;
    
    hearth_faces    = model.faces;
    hearth_vertices = model.vertices;
    
    torso_faces    = torso_model.faces;
    torso_vertices = torso_model.vertices;
    
    maxCAXIS=max(max(max(results))); % Green V=0
    maxCAXIS_Torso=max(max(abs( torso_signal(:,1:end) )));
    
    for i = 1:1:Nplot
        if i == 1
           Faces = torso_faces;
           Vertices = torso_vertices;
           Signal = torso_signal(:,t);
           max_axis = maxCAXIS_Torso;
           if strcmp(GeometryModel, 'Hearth_Geometry')
               views = [0 89; 0 0; 180 0];
               zooms = [1.5, 1.5, 1.5];
           else
                views = [0 89; 0 0; 0 -89];
                zooms = [1.8, 1.8, 1.8];
           end
        else
            Faces = hearth_faces;
            Vertices = hearth_vertices;
            Signal = results(i-1,:,t);
            Signal = Signal';
            max_axis = maxCAXIS;
            if strcmp(GeometryModel, 'Hearth_Geometry')
                views = [-90  -10;-10 40;60 -90];
                zooms = [1.3, 1.2, 1.8];
            else
                views = [0 89; 0 0; 0 -90];
                if i ~= Nplot
                    zooms = [1.6, 1, 1];
                else
                    zooms = [1.6, 1, 1];
                end
            end
        end
        
        % Plot top view
        
        subplot(3,Nplot+1,i);
        
        aux = patch('Faces', Faces,...
        'Vertices', Vertices,...
        'FaceVertexCData', Signal);

        if i == 1
            colorbar;
        end
        caxis(max_axis.*[-1 1]);
        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        if i ~= 1
            view(views(1,:));
            zoom(zooms(1));
        else
            view(views(2,:));
            zoom(zooms(1));
            view(views(1,:));
        end
        camlight('infinite'); 
        
        if i <= Nplot
            if i == 1
                ti = title(['Torso signal. t=' int2str(t)]);
                if strcmp(GeometryModel, 'Espheric_Geometry')
                    set(ti, 'Position',[0 27 50]);
                else
                    set(ti, 'Position', [0, 65]);
                end
            else
                title([StringInLines(strtrim(Matrix_names(i-1,:)),25) '. t=' int2str(t)]);
            end
        end
        
        if i == Nplot
            subplot(3,Nplot+1,Nplot+1);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end
        
        % plot middle view
        
        subplot(3,Nplot+1,Nplot+1+i);
        
        aux = patch('Faces', Faces,...
        'Vertices', Vertices,...
        'FaceVertexCData',Signal);

        if i == 1
            colorbar
        end
        caxis(max_axis.*[-1 1]);
        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        view(views(2,:));
        camlight('infinite');
        zoom(zooms(2));
        if i <= Nplot
            if i == 1
                ti = title(['Torso signal. t=' int2str(t)]);
                if strcmp(GeometryModel, 'Espheric_Geometry')
                    set(ti, 'Position',[0,-90, 30]);
                end
            else
                title([StringInLines(strtrim(Matrix_names(i-1,:)),25) '. t=' int2str(t)]);
            end
        end
        
        if i == Nplot
            subplot(3,Nplot+1,Nplot+2+i);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end
        
         % plot bottom view
        
        subplot(3,Nplot+1,(Nplot+1)*2+i);
        
        aux = patch('Faces', Faces,...
        'Vertices', Vertices,...
        'FaceVertexCData',Signal);

    
        if i == 1
            colorbar
        end
        caxis(max_axis.*[-1 1]);
        axis equal;
        shading faceted;
        axis off

        %%% Iluminacion
        lighting phong;
        material([0.3 0.4 0.3]);
        shading interp;
        view(views(3,:));
        camlight('infinite');
        if strcmp(GeometryModel, 'Espheric_Geometry')
             if i == 1
                zoom(1);
             end
        end
        zoom(zooms(3));
        if i <= Nplot
            if i == 1
                ti = title(['Torso signal. t=' int2str(t)]);
                if strcmp(GeometryModel, 'Espheric_Geometry')
                    set(ti, 'Position',[0,-26, 30]);
                end
            else
                title([StringInLines(strtrim(Matrix_names(i-1,:)),25) '. t=' int2str(t)]);
            end
        end
        
        if i == Nplot
            subplot(3,Nplot+1,(Nplot+1)*2+i+1);
            colorbar
            axis off
            caxis(maxCAXIS.*[-1 1]);
        end

    end
    
end

