function[tx]=interleavor(chip,scrambrule)
[n,chiplen]=size(chip);
for i=1:n
   for j=1:chiplen
       tx(i,j)=chip(i,scrambrule(i,j));
   end
end