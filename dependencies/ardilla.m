[sonido, fs, nbits]=wavread('vozam.wav');
[nm, c]=size(sonido);
sonido2=zeros(nm*2, c);
for i=1:nm
   sonido2(i, 1)=sonido(i, 1);
   sonido2(i+nm, 1)=sonido(i, 1);  
   if(c==2)
    sonido2(i, 2)=sonido(i, 2); 
    sonido2(i+nm, 2)=sonido(i, 2);
   end
end
if(c==2)
    new=pvoc(sonido2, 0.5, 2048);
    sound(new, fs*4);
end
if(c==1)
    new=pvoc(sonido, 0.5, 2048);
    sound(new, fs*2);
end

%new=zeros(nm, 2);
%fs2 = 44100;
%f=1;
%for i=1:(nm)
    %new(i,1)=sonido(i,1)*cos(i*2*pi*f*2);
    %new(i,2)=sonido(i,2)*cos(i*2*pi*f);
%end
%sound(new, fs2);

%new=zeros(nm*2, 2);
%transf=fft(sonido);
%for i=1:(nm)
    %new(i*2,1)=transf(i,1);
    %new(i*2,2)=transf(i,2);
%end
%sonido=ifft(new);
%sound(sonido, fs);

%f=2;
%decim = decimate(sonido, f);
%sound(decim, fs);

%ardil=zeros(nm*2, 2);
%j=1;
%for i=1:2:(nm*2-2)
    %ardil(i, 1)=sonido(j,1);
    %ardil(i, 2)=sonido(j,2);
    %ardil(i+1, 1)=sonido(j,1)*sonido(j+1, 1)/2;
    %ardil(i+1, 2)=sonido(j,2)*sonido(j+1, 2)/2;
    %j=j+1;
%end
%sound(sonido, fs);
%sound(ardil, fs);
