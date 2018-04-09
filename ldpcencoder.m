function[data2,extrabits]=ldpcencoder(in,H)
extrabits=0;
[len,len2]=size(H.ParityCheckMatrix);
[r,c]=size(in);
data=reshape(in',1,r*c);
a=floor(length(data)/len);
b=mod(length(data),len);
out=[];
for i=1:a
    x=[];
  	xx=data(1,(i-1)*len+1:i*len);
%     x=encode(encldpc, xx);
    x=step(H, xx')';
    out=cat(2,out,x);
end
if b>0
    
    xx=data(1,a*len+1:length(data));
    y=zeros(1,len);
    y(1,1:length(xx))=xx;
    x=[];
    % x=step(encldpc, y);
    % x=y;
    x=step(H, y')';
    out=cat(2,out,x);
    extrabits=len-length(xx);
end
data2=reshape(out,numel(out)/r,r)';
end






















% [len,len2]=size(H.ParityCheckMatrix);
% [r,c]=size(in);
% data=reshape(in',1,r*c);
% a=floor(length(data)/len);
% b=mod(length(data),len);
% out=[];
% for i=1:a
%     x=[];
%   	xx=data(1,(i-1)*len+1:i*len);
%     x=encode(encldpc, xx);
%     out=cat(2,out,x);
% end
% xx=data(1,a*len+1:length(data));
% y=zeros(1,len);
% y(1,1:length(xx))=xx;
% x=[];
% % x=step(encldpc, y);
% % x=y;
% x=step(H, y')';
% out=cat(2,out,x);
% extrabits=len-length(xx);
% dataout=reshape(out,numel(out)/r,r)';


% % len=H.NumInfoBits;
%  [len,len2]=size(H.ParityCheckMatrix);
% [r,c]=size(in);
% data=reshape(in',1,r*c);
% [a,b]=one2twof1(length(data),len);
% out=[];
% for i=1:a
%     x=[];
%   	xx=data(1,(i-1)*len+1:i*len);
% %     x=encode(encldpc, xx);
%     x=step(H, xx')';
%     out=cat(2,out,x);
% end
% xx=data(1,a*len+1:length(data));
% y=zeros(1,len);
% y(1,1:length(xx))=xx;
% x=[];
% % x=encode(encldpc, y);
% x=step(H, y')';
% out=cat(2,out,x);
% extrabits=len-length(xx);
% dataout=reshape(out,numel(out)/r,r)';
% end
% 
% function[a,b]=one2twof1(x,n)
%     a=floor(x/n);
%     b=mod(x,n);
% end


