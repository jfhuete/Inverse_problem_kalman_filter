%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Save Figures for one vertex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    saveas(fig1,[path '/figures/Result_v'...
            num2str(vertex) '.fig'], 'fig');
    saveas(fig1,[path '/images/Result_v'...
            num2str(vertex) '.jpg']);
catch ME
    if strcmp(ME.identifier,...
              'MATLAB:saveas:invalidHandle')
        fig1 = figure(1);

        saveas(fig1,[path '/figures/Result_v'...
                num2str(vertex) '.fig'], 'fig');
        saveas(fig1,[path '/images/Result_v'...
                num2str(vertex) '.jpg']);
    else
        rethrow(ME);
    end;
end;