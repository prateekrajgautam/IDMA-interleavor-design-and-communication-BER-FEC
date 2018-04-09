function[b]=bitsrequired(M)
% if mod(M,2)~=0
%    disp('enter a suitable value for M ''in power of (2)''')
% end
for i=1:100
    if 2^i==M
        b=i;
        break
    end
    if 2^i>M
        b=i;
        break
    end        
end
end