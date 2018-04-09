function[out]=ldpcdec1(in,gg)
[r,c]=size(in);
in2=reshape(in',1,numel(in))';
in3   = step(gg, double(in2));
% modSignal      = step(hMod, encodedData);
% in3    = double(step(hDemod, modSignal));  
out=reshape(in3,numel(in3)/r,r)';
end