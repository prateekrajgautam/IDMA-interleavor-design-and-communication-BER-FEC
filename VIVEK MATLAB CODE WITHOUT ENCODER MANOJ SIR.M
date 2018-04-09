clear         
clc
block=20;
n=8;                    %no.of users
m=512;                  %data length
sl=16;                 %spread length
chiplen=m*sl;        %chip length
itnum=5;
ebnostart=0;     %step iteration
ebnostep=3;
ebnonum=5;
M=4;
 
 
%energy profile generation begins
if n==8
for i=1:25
h2(i)=1.000;
end
for i=26:32
h2(i)=3.4523;
end
end
tmp=0;
for i=1:n
tmp=tmp+h2(i);
end
for i=1:n
h2(i)=n*h2(i)/tmp;
end
for i=1:n
h(i)=sqrt(h2(i));
end
%energy profile generation ends
 
 
%spreading sequence producing {+1,-1,+1,-1--------}
for i=1:sl
    spreading(1,i)=1-2*rem(i-1,2);
end
%spreading sequence generation ends
 
%interleaving sequence generation begins
for i=1:n
    for j=1:chiplen
        scrambrule(i,j)=j;
        first(i,j)=j;
    end
    for j=1:chiplen
        k=j+rem(randint(1,1,1000)*randint(1,1,1000),(chiplen+1-j));
        tmp=scrambrule(i,j);
        scrambrule(i,j)=scrambrule(i,k);
        scrambrule(i,k)=tmp;
    end            
end
%interleave design ends
 
%the simulation process begins
for z=1:ebnonum
    ebno=ebnostart+z*ebnostep;
    snr(z)=(10.^(ebno/10))/sl;
    sigma=sqrt(0.5/snr(z));
    error=0;
    for bloc=1:block
        
        
        %transmitter section begins
        %generation of data randomly
        for i=1:n
            for j=1:m
                data(i,j)=randint(1,1);
            end
        end
        %end of generation of data
        
        %data spreading begins
        for i=1:n
            l=1;
            for j=1:m
                tmp=1-2*data(i,j);
                for s=1:sl
                    chip(i,l)=tmp*spreading(1,s);
                    l=l+1;
                end
            end
        end
        %end of data spreading
       
       %transmitting data production begins 
       for i=1:n
           for j=1:chiplen
               transmit(i,j)=chip(i,scrambrule(i,j));
               
           end
       end
       %transmitting data produced
      %transmitter section ends
    
      
      %coding for channel begins with noise
      for i=1:chiplen
          tmp=rand(1,1);
          receive(i)=sigma*sqrt(-2.0*log(tmp))*cos(6.283185307*tmp);
          for j=1:n
              receive(i)=receive(i)+h(j)*transmit(j,i);
          end
      end
      %coding for channel ends
      
      
      %coding for receiver section begins
      
      %coding for sigma intialization begins
      s2=sigma*sigma;
      for i=1:chiplen
          totalmean(i)=0;
          totalvar(i)=s2;
      end
      for i=1:n
          for j=1:chiplen
              mean(i,j)=0;
              var(i,j)=h2(i);
              totalvar(j)=totalvar(j)+h2(i);
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
                 chip(i,scrambrule(i,j))=2*h(i)*(receive(j)-totalmean(j))/totalvar(j);
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
             
             %%%feed the appllr to decoder, if there is FEC coding.
             
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
                 mean(i,j)=h(i)*tanh(ext(i,scrambrule(i,j))/2);
                 var(i,j)=h2(i)-mean(i,j)*mean(i,j);
                 totalmean(j)=totalmean(j)+mean(i,j);
                 totalvar(j)=totalvar(j)+var(i,j);
             end
             %updating is finished
             
         end
     end
     %iterative loop ends
     
     %code for receiver section ends
     
     
     %code for error calculation begins
     e=0;
     for i=1:n
         for j=1:m
             if appllr(i,j)>0
                 appllrf(i,j)=0;
             else
                 appllrf(i,j)=1;
             end
             if data(i,j)~=appllrf(i,j)
                 e=e+1;
             end
         end
     end
     
     error=error+e;
     %code for error calculation ends
     
     ebno   
     bloc
     ber=(error/(n*m*bloc))
    end
    ebn(z)=ebno;
    ber1(z)=ber;
end
 
   semilogy(ebn,ber1,'--k^','LineWidth',2,...
                'MarkerEdgeColor','g',...
                'MarkerFaceColor','r',...
                'MarkerSize',10)            
           xlabel('Eb/No')
            ylabel('Bit Error Rate')
           grid on
           hold on 
           


