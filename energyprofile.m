
function[h]=energyprofile(n,a,b);
h2=a:(b-a)/(n-1):b;
tmp=sum(h2);
h1=(n/tmp)*h2;
h=sqrt(h1);
end