function[out]=ldpcenc1(data,hh)
in=data;
[r,c]=size(in);
in2=reshape(in',1,numel(in))';
in3   = step(hh, double(in2));
out=reshape(in3',numel(in3)/r,r)';


% [r,c]=size(data);
% data1=reshape(data',1,numel(data))';
% encodedData    = step(hh, data1);
% modSignal      = step(hMod, encodedData);
% demodSignal    = double(step(hDemod, modSignal));
% out=reshape(demodSignal,numel(demodSignal)/r,r)';
end
    