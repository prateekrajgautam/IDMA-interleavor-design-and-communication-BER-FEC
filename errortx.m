function[error,ber]=errortx(x,y)
%[error,ber]=error(tx,rx)
% to calculate 'error bits' & 'ber' between transmitted & recieved data
% it will add 1 bit error if there is no error so that error & ber can be plotted in matlab
% by PRATEEK RAJ GAUTAM
%-------------------------------------------
if nargin==2
    [r1,c1]=size(x);
    [r2,c2]=size(y);
    x=reshape(x,1,r1*c1);
    y=reshape(y,1,r2*c2);
    [r1,c1]=size(x);
    [r2,c2]=size(y);
    
    if r1~=r2||c1~=c2
        disp('size of matrix must be equal')
        error='error matrix dimension';
        ber='error matrix dimension';
    end
    if r1==r2&&c2==c1
        [r c]=size(y);
        x=reshape(x,1,r*c);
        y=reshape(y,1,r*c);
        e1=x-y;
        e2=e1*e1';
        error=sum(e2);
%         if error==0
%           error=error+1;%to make it visible in matpab plot
%         end
%         ber=error/(users_max*bits);
%         ber=error/(r*c);
        ber=error/numel(x);
    end
elseif nargin~=2
    disp('enter 2 matrix of equal size to calculate error & BER')
end
end