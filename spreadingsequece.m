function[out]=spreadingsequece(sl,in)
int=numel(in);
len=sl/int;
out1=ones(len,1)*in;
out=reshape(out1',1,numel(out1));
end
