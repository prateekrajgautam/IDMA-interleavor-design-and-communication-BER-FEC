for index=1:4
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
end
    saveas(gcf,[name num2str(index)],'jpg');
    save(name);