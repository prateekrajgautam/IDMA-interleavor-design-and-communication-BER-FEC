function[x]=idmascramble(n,chiplen)
for i=1:n
    x(i,:)=[1:chiplen];
    for j=1:chiplen
        rep=randi(chiplen,1);
        swap=x(i,j);
        x(i,j)=x(i,rep);
        x(i,rep)=swap;
    end           
end