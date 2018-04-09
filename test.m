freshfigure=1;%  set this option 1 for fresh figure & 2 to plot fresh figure on previous plot

if freshfigure==1
    clear all
    close all
    plotcolor=['-b^';'-g*';'-ro';'-cx';'-ks';'-yd';'-mp';'-wh'];
    freshfigure=1;
    legname=[];
    marksize=10;
    linewidth=1;
    index=1;
    legname=[];
elseif freshfigure~=1
    clearvars -except legname marksize linewidth index ber1 ebn name plotcolor
    hold on
    freshfigure=1;
    marksize=marksize+2;
    linewidth=linewidth+1;
    index=index+1
end
clc

%% user defined variables starts

block=1;
n=4;                %no.of users
m=512;              %data length
sl=64;              %spread length
chiplen=m*sl;       %chip length
itnum=5;            %no of iteration
ebnostart=0;        %step iteration
ebnostep=3;
ebnonum=5;
M=1;
useldpc=[];
% useldpc=0; %set useldpc to one(1) to use ldpd encoder & decoder else set it to 2
useenergyprofile=0;%set useenergyprofile to one(1) to use useenergyprofile  else set it to 2
usemodem=1; %select modulation type '1 for psk 2 for dpsk'

%% user defined variables ends

%% program starts
bx=bitsrequired(M);
while mod(M,2^bx)~=0
    M=input('enter a suitable value for M ''in power of 2'' ')
    bx=bitsrequired(M);
end


if useenergyprofile==1
%     [ep]=energyprofile(n,1,3.4523);
    ep=interleavor(energyprofile(n,1,3.4523),idmascramble(1,n));% energy profile power for n users in ep
    
end

switch usemodem
    case 1 %psk
        modulationname='mpsk';
        h=modem.pskmod(M);
        g=modem.pskdemod(M);
    case 2 %dpsk
        modulationname='mdpsk';
        h=modem.dpskmod('M', M);
        g=modem.dpskdemod('M', M);
%     case 3 %%qam
%         modulationname='qam';
%         h=modem.qammod('M', M);
%         g=modem.qamdemod('M', M);
%     case 4 %%pam
%         modulationname='pam';
%         h=modem.pammod('M', M);
%         g=modem.pamdemod('M', M);
    otherwise %psk
        modulationname='psk';
        h=modem.pskmod(M);
        g=modem.pskdemod(M);
end


% if useldpc==1
% %% ldpc encoder decoder
%     hh= comm.LDPCEncoder;
%     gg = comm.LDPCDecoder; 
%     [len,len2]=size(hh.ParityCheckMatrix);
%       m=len/n;
%       m2=len2/n;
%       chiplen=m2*sl;
%       block=1;% to reduce iterations to speed up
% end
      

  
b=bitsrequired(M);

% if useenergyprofile==1
%     hk=energyprofile(n,1,3.4523);
% else
%     hk=ones(1,n);%assume we know h_k required for idma decoder
% end

hk=ones(1,n);%assume we know h_k required for idma decoder

%% idma 
spreadingunipolar=spreadingsequece(sl,[1,0]);%spreading sequence producing {1,0,1,0--------}
spreading=2*spreadingunipolar-1;
% if useldpc==1
%     scrambrule=idmascramble(n,chiplen);%interleaver design
% else
    scrambrule=idmascramble(n,chiplen);  
% end
%% the simulation process begins
for z=1:ebnonum
    ebno=ebnostart+z*ebnostep;
    snr(z)=(10.^(ebno/10))/sl;
    sigma=sqrt(0.5/snr(z));
    error=0;    
    for bloc=1:block
        
%% ========================================================================
%%                     transmitter
        %% transmitter section begins
        data=randint(n,m,[1,0]);                %generation of random bipolar data    
%         if useldpc==1
%             data2=ldpcenc1(data,hh);
%         else
            data2=data;
%         end
        chip=spreador(spreadingunipolar,data2);   
        transmit1=interleavor(chip,scrambrule);       %transmitting data interleavor   
        %% bpsk encoder to transmit & apply energy profile
            if useenergyprofile==1
                transmittemp=2*((transmit1)>0)-1;
                for zz=1:n
                    transmit2(zz,:)=ep(1,zz)*transmittemp(zz,:);
                end
            else
                transmit2=2*((transmit1)>0)-1;
            end
        %% idma multipleser (sum)
            tx3=sum(transmit2);
        %% normaliser & quantiser
            [tx4,lenq]=quantiser(tx3,n);
        %% mpskmodulator
            [tx5,appendbit]=modulator(tx4,b,h);

            
            
%% ========================================================================
%%                      channel
        %% awgn channel
            y0=channelnoise(tx5,ebno);
%             %% bipass channelnoise
%             y0=[];y0=tx5;




%% ========================================================================
%%                     reciever
        %% mpskdemodulator
            y1=demodulator(y0,g);
        %%remove append 
            y11=y1(1,1:length(y1)-appendbit);
        %% dequantiser & denormalizer
            y2=dequantiser(y11,n);
        %% idma decoder
        appllr=idmadecoderbpsk(sigma,hk,n,m,sl,itnum,chiplen,y2,spreading,scrambrule,useldpc);
        e=0;
        appllrf=appllr>0;% decision whether 1 or 0 is recieved
%         recieveddata=step(appllrf,gldpc);
%         if useldpc==1
%             decodeddata=ldpcdec1(appllrf,gg);
%         else
            decodeddata=appllrf;
%         end
        [e,bertemp]=errortx(data,decodeddata);% check error
        error=error+e;       
        % code for error calculation ends
        ber=(error/(n*m*bloc));
        [z,bloc,ebno,ber]
    end
%     scatterplot(y0),grid
    ebn(index,z)=ebno;
    ber1(index,z)=ber;
end

%% ========================================================================
%% plotting result 
   semilogy(ebn(index,:),ber1(index,:),plotcolor(index,:),'LineWidth',2,...
                'MarkerEdgeColor','g',...
                'MarkerFaceColor','r',...
                'MarkerSize',marksize)           
    xlabel('Eb/No')
    ylabel('Bit Error Rate')
    grid on
    hold on
    if index==1
       name=[modulationname '_with_M=' num2str(M) ',no_of_users=' num2str(n) ',datalength=' num2str(m) ',spreadinglength=' num2str(sl) ',useenergyprofile=' num2str(useenergyprofile) ];
       lname=[modulationname ' M=' num2str(M) ',users=' num2str(n)];
    elseif index>1
       name=[' compare' modulationname '_with_M=' num2str(M) ',no_of_users=' num2str(n) ',datalength=' num2str(m) ',spreadinglength=' num2str(sl) ',useenergyprofile=' num2str(useenergyprofile) name ];
       lname=[modulationname ' M=' num2str(M) ',users=' num2str(n) ];
    end
%     legname(index,:)=[lname];
    ber1
    ebn
    legname{index}=lname;%cat(1,legname,{[lname ',']})
    legend(legname)
    saveas(gcf,[name num2str(index)],'jpg');
    save(name);