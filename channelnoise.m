function[y]=channelnoise(x,ebno)
y=awgn(x,ebno,'measured');
end