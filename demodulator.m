function[out]=emodulator(a,g)
% M=2^b;
% g=modem.pskdemod(M);
% g=modem.pskdemod(M,pi/M+pi/2);
out1=demodulate(g,a);
out2=dec2bin(out1);
out=reshape(out2',1,numel(out2));
% out=demodulate(modem.pskdemod(2^b),a);