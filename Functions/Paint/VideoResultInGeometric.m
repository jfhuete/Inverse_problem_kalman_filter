function [video] = VideoResultInGeometric(vw, model, results, samples, plot_title, Matrix_names, Parameters_Text)

open(vw);
t = 0;
for s = samples
    t =t+1;
    aux=PlotResultsInGeometric(model, t, results, plot_title, Matrix_names, Parameters_Text);
    video(t)=getframe(gcf);
    if s ~= samples(end)
        delete(aux);
        clf;
    end;
end
writeVideo(vw, video);
close(vw);

end

