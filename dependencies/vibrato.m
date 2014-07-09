[sonido, fs, nbits]=wavread('../audio/aaa.wav');
[nm, c]=size(sonido);
new=zeros(nm, c);
f=8000;
for i=1:c
    for j=1:nm
        new(j, i)=sonido(j, i)*(3*cos(j*pi/f));
    end  
end
sound(new, fs);