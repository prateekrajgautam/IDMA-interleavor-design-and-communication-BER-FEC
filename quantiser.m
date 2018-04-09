function[tx4,lenq]=quantiser(tx3,n)
normalisatonfactor=ceil(min(tx3)*-1)+1;
x=tx3+normalisatonfactor;
[r,c]=size(x);
lenq=bitsrequired(2*n+1);
x1=dec2bin(x',lenq);
tx4=reshape(x1',1,numel(x1));
end
