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
handles.k = 1;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
option = get(hObject,'Tag');
if option == 'radiobutton1'
    %--- Zeus ---%
    sonido = handles.sound';
    fs = handles.fs;
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
        sonido=pvoc(sonido2, 2, 2048);
    end
    if(c==1)
        sonido=pvoc(sonido, 2, 2048);
        fs=fs/2;
    end
    handles.newfs=fs;
    handles.result=sonido;
    guidata(hObject,handles);
elseif option == 'radiobutton2'
    %--- Ardilla ---%
    sonido = handles.sound';
    fs = handles.fs;
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
        sonido=pvoc(sonido2, 0.5, 2048);
        fs=fs*4;
    end
    if(c==1)
        sonido=pvoc(sonido, 0.5, 2048);
        fs=fs*2;
    end
    handles.newfs=fs;
    handles.result=sonido;
    guidata(hObject,handles);
elseif option == 'radiobutton3'    
    %--- Eco ---%
    sound = handles.sound;
    fs = handles.fs;
    delay = 0.15;
    decay = 0.6;
    k = zeros(1,delay*fs+2);
    k(1) = decay;
    k(end) = 1-decay;
    result = conv(sound,k);
    handles.result = result;
    handles.newfs=fs;
    guidata(hObject,handles)
elseif option == 'radiobutton4'
    %--- Reverberación ---%
    sound = handles.sound;
    fs = handles.fs;
    k = zeros(1,fs*0.5);
    k(1) = 0.5;
    k(0.01*fs) = 0.3;
    k(0.1*fs) = 0.1;
    k(0.2*fs) = 0.05;
    k(0.3*fs) = 0.03;
    k(0.4*fs) = 0.01;
    k(0.5*fs) = 0.01;
    result = conv(sound,k);
    handles.result = result;
    handles.newfs=fs;
    guidata(hObject,handles);
elseif option == 'radiobutton5'
    %--- Vibrato---%
    sonido = handles.sound;
    sonido = sonido';
    fs = handles.fs;
    [nm, c]=size(sonido);
    f=8000;
    for i=1:c
        for j=1:nm
            sonido(j, i)=sonido(j, i)*(3*cos(j*pi/f));
        end  
    end
    handles.result = sonido;
    handles.newfs=fs;
    guidata(hObject,handles);
elseif option == 'radiobutton6'
    %--- Wah Wah ---%
    % src: http://www.cs.cf.ac.uk/Dave/CM0268/PDF/10_CM0268_Audio_FX.pdf
    sound = handles.sound;
    Fs = handles.fs;
    damp = 0.05; % damping factor
    minf=500;
    maxf=3000;
    Fw = 2000; % wah frequency 
    delta = Fw/Fs;
    Fc = minf:delta:maxf; % triangle wave of centre frequency values
    while(length(Fc) < length(sound) )
        Fc= [ Fc (maxf:-delta:minf) ];
        Fc= [ Fc (minf:delta:maxf) ];
    end
    Fc = Fc(1:length(sound));
    F1 = 2*sin((pi*Fc(1))/Fs);
    Q1 = 2*damp;                % Size of the pass bands
    yh=zeros(size(sound));
    yb=zeros(size(sound));
    yl=zeros(size(sound));
    yh(1) = sound(1);
    yb(1) = F1*yh(1);
    yl(1) = F1*yb(1);
    for n=2:length(sound),
        yh(n) = sound(n) - yl(n-1) - Q1*yb(n-1);
        yb(n) = F1*yh(n) + yb(n-1);
        yl(n) = F1*yb(n) + yl(n-1);
        F1 = 2*sin((pi*Fc(n))/Fs);
    end
    %normalise
    maxyb = max(abs(yb));
    yb = yb/maxyb;
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
    result = handles.result;
    fs = handles.newfs;
    sound(result,fs);
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%less
k = handles.k;
disp(k);
sound = handles.sound;
if k >= 0.2
    k = k - 0.1;
    output = sound*k;
    sound = output;
end
handles.sound = sound;
handles.k = k;
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
%more
k = handles.k;
disp(k);
sound = handles.sound;
if k <= 1.9
    k = k + 0.1;
    output = sound*k;
    sound = output;
end
handles.sound = sound;
handles.k = k;
guidata(hObject,handles);


function uipanel1_CreateFcn(hObject, eventdata, handles)
function pushbutton1_CreateFcn(hObject, eventdata, handles)
function pushbutton1_DeleteFcn(hObject, eventdata, handles)
