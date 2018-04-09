function[out]=spreador(code,x1)%spreador
[r,c]=size(x1);
x=not(x1);
for i=1:r
    y=[];
% y=x(i,:)'*code;
for j=1:c
    y(j,:)=xor(x(i,j)',code);
end
out(i,:)=reshape(y',1,numel(y));
end