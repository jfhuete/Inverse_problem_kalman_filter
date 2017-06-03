function [] = ComparePlotVideo2D( A, B, c_A, c_B, t )
% COMPAREPLOTVIDEO2D Plot video of phi_E and 
% phi_T for a specific position

for i=0:t
    subplot(2,1,1)
    plot(A(c_A,1:i))
    xlim([0 t])
    ylim([min(A(c_A,:)) max(A(c_A,:))])
    subplot(2,1,2)
    plot(B(c_B,1:i))
    xlim([0 t])
    ylim([min(B(c_B,:)) max(B(c_B,:))])
    pause(0.00001)
end
end

