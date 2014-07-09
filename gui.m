function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
try
    [sound,fs,N] = wavread(getappdata(0,'fullpath'));
catch
    sound = getappdata(0,'fullpath');
    fs = 44100;
    N = 16;
end
sound = sound';
% Save global values
handles.ispushed = 0;
handles.sound = sound;
handles.fs = fs;
handles.newfs = fs;
handles.k = 0.5;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
set(handles.slider3,'Value',0.5);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
option = get(hObject,'Tag');
if option == 'radiobutton1'
    %--- Zeus ---%
    %http://www.ee.columbia.edu/~dpwe/resources/matlab/pvoc/
    %http://www.mathworks.com/matlabcentral/fileexchange/45441-phase-vocoder/content/phase_vocoder/pvoc.m
    sonido = handles.sound'; %transpongo los datos del audio para trabajarlos normal
    fs = handles.fs;
    [nm, c]=size(sonido); %obtengo el numero de muestras y el numero de canal
    sonido2=zeros(nm*2, c); %creo un sonido 2 que tendra el doble de tamaño que el audio original
    for i=1:nm
       sonido2(i, 1)=sonido(i, 1); %copio los datos del audio original
       sonido2(i+nm, 1)=sonido(i, 1); %repito los datos del audio desde la mitad del nuevo audio
       if(c==2)
        sonido2(i, 2)=sonido(i, 2); %lo mismo si el archivo tiene 2 canales de audio
        sonido2(i+nm, 2)=sonido(i, 2);
       end
    end
    %la funcion pvoc me escala la informacion en el tiempo del audio sin cambiarme el pitch
    %sin embargo, tiene diferentes efectos para 1 canal y 2 canales
    %ademas, me retorna solo la mitad del audio, por eso duplicamos el
    %audio principal en un mismo archivo
    if(c==2)
        sonido=pvoc(sonido2, 2, 2048);% 2-->1/2 del tiempo original
    end
    if(c==1)
        sonido=pvoc(sonido, 2, 2048);
        fs=fs/2;
    end
    handles.newfs=fs;
    handles.result=sonido;%guardo el resultado y la frecuencia a la que lo rerpoducire
    guidata(hObject,handles);
elseif option == 'radiobutton2'
    %--- Ardilla ---%
    %realizo los mismos pasos que en Zeus
    sonido = handles.sound';
    fs = handles.fs;
    [nm, c]=size(sonido);
    sonido2=zeros(nm*2, c);
    for i=1:nm
       %duplico la duración del audio en un nuevo archivo
       sonido2(i, 1)=sonido(i, 1); 
       sonido2(i+nm, 1)=sonido(i, 1);  
       if(c==2)
        sonido2(i, 2)=sonido(i, 2); 
        sonido2(i+nm, 2)=sonido(i, 2);
       end
    end
    %de igual manera diferentes resultados para 1 y 2 canales
    if(c==2)
        sonido=pvoc(sonido2, 0.5, 2048); %0.5-->2 veces la duracion del audio
        fs=fs*4;
    end
    if(c==1)
        sonido=pvoc(sonido, 0.5, 2048);
        fs=fs*2;
    end
    handles.newfs=fs;%guardo los resultados para posterior uso
    handles.result=sonido;
    guidata(hObject,handles);
elseif option == 'radiobutton3'    
    %--- Eco ---%
    sound = handles.sound;
    fs = handles.fs;
    delay = 0.15; %retardo del eco
    decay = 0.6; %potencia del audio original
    k = zeros(1,delay*fs+2); %creo un kernel con eco luego de 0.15 segundos del audio 
    k(1) = decay;
    k(end) = 1-decay; %potencia del audio eco
    result = conv(sound,k); %uso convolución para aplicar el kernel
    handles.result = result; %guardo los resultados en las variables globales
    handles.newfs=fs;
    guidata(hObject,handles)
elseif option == 'radiobutton4'
    %--- Reverberación ---%
    sound = handles.sound;
    fs = handles.fs;
    k = zeros(1,fs*0.5); %creo un kernel de duracion 0.5 segundos.
    k(1) = 0.5; %potencia del audio original
    k(0.01*fs) = 0.3; %Ajusto una cola que comience desde el 0.1 segundo del audio original
    k(0.1*fs) = 0.1; %potencias para cada pulso de la cola
    k(0.2*fs) = 0.05;
    k(0.3*fs) = 0.03;
    k(0.4*fs) = 0.01;
    k(0.5*fs) = 0.01;
    result = conv(sound,k); %aplico convolucion para obtener mi audio con reverberación
    handles.result = result; %guardo los resultados.
    handles.newfs=fs;
    guidata(hObject,handles);
elseif option == 'radiobutton5'
    %--- Vibrato---%
    sonido = handles.sound;
    sonido = sonido'; %transpongo los datos del audio para trabajarlo
    fs = handles.fs;
    [nm, c]=size(sonido); %obtengo numero de muestras y numero de canales
    f=8000; %frecuencia con la que construire mi función coseno
    for i=1:c
        for j=1:nm
            sonido(j, i)=sonido(j, i)*(3*cos(j*pi/f)); %sumo cada punto de la función coseno con la señal original para tener altos y bajos -vibrato-
        end  
    end
    handles.result = sonido;%guardo los resultados
    handles.newfs=fs;
    guidata(hObject,handles);
elseif option == 'radiobutton6'
    %--- Wah Wah ---%
    % src: http://www.cs.cf.ac.uk/Dave/CM0268/PDF/10_CM0268_Audio_FX.pdf
    sound = handles.sound;
    Fs = handles.fs;
    damp = 0.05; % factor
    minf=500; % Frecuencia mínima
    maxf=3000; % Frecuencia máxima
    Fw = 2000; % frecuencia del wah 
    delta = Fw/Fs;
    Fc = minf:delta:maxf; % Onda triangular con valores centrales de frecuencia
    while(length(Fc) < length(sound) )
        Fc= [ Fc (maxf:-delta:minf) ];
        Fc= [ Fc (minf:delta:maxf) ];
    end
    Fc = Fc(1:length(sound));
    F1 = 2*sin((pi*Fc(1))/Fs);
    Q1 = 2*damp; % Tamaño del pasabanda
    yh=zeros(size(sound));
    yb=zeros(size(sound));
    yl=zeros(size(sound));
    yh(1) = sound(1);
    yb(1) = F1*yh(1);
    yl(1) = F1*yb(1);
    % Se genera el efecto
    for n=2:length(sound),
        yh(n) = sound(n) - yl(n-1) - Q1*yb(n-1);
        yb(n) = F1*yh(n) + yb(n-1);
        yl(n) = F1*yb(n) + yl(n-1);
        F1 = 2*sin((pi*Fc(n))/Fs);
    end
    %normaliso
    maxyb = max(abs(yb));
    yb = yb/maxyb;
    %Se guarda el resultado
    handles.result = yb;
    handles.newfs=Fs;
    guidata(hObject,handles);
elseif option == 'radiobutton7'
    handles.result = handles.sound;
    handles.newfs = handles.fs;
    guidata(hObject,handles);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
isPushed = handles.ispushed;
isPushed = ~isPushed;
if isPushed
    set(hObject,'String','Detener','ForegroundColor','red');
    result = handles.result; %obtengo el resultado con su respectiva frecuencia
    fs = handles.newfs;
    k = handles.k;
    result = result * k;
    sound(result,fs);%Reprodusco el audio
else
    clear playsnd
    set(hObject,'String','Reproducir','ForegroundColor','green');
end
handles.ispushed = isPushed;
guidata(hObject,handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%close
clear playsnd;
rmappdata(0,'fullpath');
delete(handles.output);
index


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
k = get(hObject,'Value');
sound = handles.sound;
sound = sound*k;
handles.k = k;
handles.result = sound;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function uipanel1_CreateFcn(hObject, eventdata, handles)
function pushbutton1_CreateFcn(hObject, eventdata, handles)
function pushbutton1_DeleteFcn(hObject, eventdata, handles)
