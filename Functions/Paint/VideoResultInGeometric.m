function [video] = VideoResultInGeometric(vw, model,torso_model, results,torso_signal, samples, plot_title, Matrix_names, Parameters_Text)

    open(vw);
    t = 0;
    for s = samples
        t =t+1;
        aux=PlotResultsInGeometric(model,torso_model, t, results,torso_signal, plot_title, Matrix_names, Parameters_Text);
        video(t)=getframe(gcf);
        if s ~= samples(end)
            delete(aux);
            clf;
        end;
    end
    writeVideo(vw, video);
    close(vw);

end

