function[decodeddata]=ldpcdecoder(datain,G,extrabits)
[len,len2]=size(G.ParityCheckMatrix);
[r,c]=size(datain);
data2=[];
data2=reshape(datain',1,r*c);



a=floor(length(data2)/len2);
b=mod(length(data2),len2);
out=[];
for i=1:a
    x=[];
  	xx=data2(1,(i-1)*len2+1:i*len2);
%     x=encode(encldpc, xx);
    x=step(G, xx')';
    out=cat(2,out,x);
end

data3= out;



% data3=data2;
data4=data3(1,1:length(data3)-extrabits);
data5=xor(data4,ones(1,length(data4)));
decodeddata=reshape(data5,numel(data5)/r,r)';



% [r,c]=size(datain);
% data2=reshape(datain',1,r*c);
% data3= step(G,data2')';
% data4=data3(1,1:length(data3)-extrabits);
% decodeddata=reshape(data4,numel(data4)/r,r)';
end