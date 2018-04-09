function[appllr]=idmadecoderbpsk(sigma,hk,n,m,sl,itnum,chiplen,receive,spreading,scrambrule,useldpc)
if nargin==10
   useldpc=0
end
if useldpc==1
    m=m*2;
end
    s2=sigma*sigma;
    totalmean=zeros(1,chiplen);
    totalvar=s2*ones(1,chiplen);
    mean=zeros(n,chiplen);
    for i=1:n
        var(i,:)=hk(i)*ones(1,chiplen);
        for j=1:chiplen
            totalvar(j)=totalvar(j)+hk(i);
        end
    end
    %coding for sigma initialization ends
    %iterative loop begins
    for it=1:itnum
        for i=1:n
            %produce LLR values for de-interleaved chip sequence
            for j=1:chiplen
                totalmean(j)=totalmean(j)-mean(i,j);
                totalvar(j)=totalvar(j)-var(i,j);
                chip(i,scrambrule(i,j))=2*hk(i)*(receive(j)-totalmean(j))/totalvar(j);
            end
            %end of production of LLR values
            %despreading operation begins
            l=1;
            for j=1:m
                appllr(i,j)=spreading(1,1)*chip(i,l);
                l=l+1;
                for s=2:sl
                    appllr(i,j)=appllr(i,j)+spreading(1,s)*chip(i,l);
                    l=l+1;
                end
            end
            %despreading operation ends
         %%feed the appllr to decoder, if there is FEC coding.
         %spreading: produce extrinsic LLR for each chip
         y=1;
         for j=1:m
             for s=1:sl
                 ext(i,y)=spreading(1,s)*appllr(i,j)-chip(i,y);
                 y=y+1;
             end
         end
         %extrinsic LLR calculation is over
         %updating the static variable together with interleaving
         for j=1:chiplen
             mean(i,j)=hk(i)*tanh(ext(i,scrambrule(i,j))/2);
             var(i,j)=hk(i)-mean(i,j)*mean(i,j);
             totalmean(j)=totalmean(j)+mean(i,j);
             totalvar(j)=totalvar(j)+var(i,j);
         end
         %updating is finished
     end
    end
end