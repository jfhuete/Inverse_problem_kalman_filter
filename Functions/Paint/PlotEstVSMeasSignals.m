function [ f ] = PlotEstVSMeasSignals(torso_signal, signal,signal_est,HQ,instants,vertex)

    % This functions plot the meassured signal vs estimated signal
    f = figure(1);
    subplot(3,1,1);
    plot(instants, torso_signal(320,:),'r');
    title(['Real vs Estimate Epicardial potential for node ' int2str(vertex)]);
    xlabel('Time instants');
    ylabel('Torso Potential node 320 (mv)');
    max_value = max(max(torso_signal(320,:)));
    min_value = min(min(torso_signal(320,:)));
    YInterval = max_value - min_value;
    YMargin = YInterval/2;
    axis([min(instants), max(instants),min_value-YMargin,max_value+YMargin])
    subplot(3,1,2);
    plot(instants,signal(vertex,:),'r');
    hold on;
    plot(instants,signal_est(vertex,:),'b');
    max_value = max(max(signal(vertex,:), signal_est(vertex,:)));
    min_value = min(min(signal(vertex,:), signal_est(vertex,:)));
    YInterval = max_value - min_value;
    YMargin = YInterval/2;
    axis([min(instants), max(instants),min_value-YMargin,max_value+YMargin])
    xlabel('Time instants');
    ylabel('Epicardial Potential (mv)');
    legend('Real epicardial potential',...
           'Estimate epicardial potential',...
           'location','Southeast');
    
    % Plot H quality
    subplot(3,1,3)
    plot(instants,HQ(vertex,:),'r');
    title('Quality of H Matrix. 0 Is the best value')
    xlabel('Time instants');
    ylabel('HQ');
    max_value = max(max(HQ(vertex,:)));
    min_value = min(min(HQ(vertex,:)));
    YInterval = max_value - min_value;
    YMargin = YInterval/2;
    axis([min(instants), max(instants),min_value-YMargin,max_value+YMargin])
    hold off;
    
    set(f, 'Position', [50, 50, 800, 600]);    
end

