function [ outSignal ] = addwhitenoise( inSignal, SNR)

PowerInSig=var(inSignal);
PowerInSig=mean(PowerInSig);
PowerInSigdB=10*log10(PowerInSig);
outSignal=zeros(size(inSignal));

for i=1:size(inSignal,1)
    outSignal(i,:) = awgn(inSignal(i,:), SNR, PowerInSigdB);
end

end

