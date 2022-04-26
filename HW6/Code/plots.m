clear all;
close all;
load time.txt
%load strong20.txt
%load strong800.txt
%load weak.txt

speedup = time(1)./time;
%speedup = strong20(1)./strong20;
%speedup = strong800(1)./strong800;
%speedup = weak(1)./weak;
eff = speedup./linspace(1,16,16);

%figure(1)
plot(linspace(1,16,16),speedup,'--mo')
xlabel('no. of threads');
ylabel('speedup');
print -djpeg speedup.jpg;
%print -djpeg strong20_speedup.jpg;
%print -djpeg strong800_speedup.jpg;
%print -djpeg weak_speedup.jpeg;

%figure(2)
plot(linspace(1,16,16),eff,'--mo')
xlabel('no. of threads');
ylabel('efficiency');
print -djpeg efficiency.jpg;
%print -djpeg strong20_efficiecy.jpg;
%print -djpeg strong800_efficiency.jpg;
%print -djpeg weak_efficiency.jpg; 
