function[y2]=dequantiser(y1,n)
lenq=bitsrequired(2*n+1);
x=reshape(y1,lenq,numel(y1)/lenq)';
x1=bin2dec(x);
y2=(x1-n)';