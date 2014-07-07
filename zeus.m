[sonido, fs, nbits]=wavread('hootie.wav');
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
    new=pvoc(sonido2, 2, 2048);
    sound(new, fs);
end
if(c==1)
    new=pvoc(sonido, 2, 2048);
    sound(new, fs/2);
end
