function [] = AddSignalInFigure(fig, instants, signal, vertex)
    % This functions plot a signal in a specific figure
    figure(fig);
    hold on;
    plot(instants, signal(vertex,:));
    hold off;

end

