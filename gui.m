function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 06-Jul-2014 14:27:32

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
[audio,fs,N] = wavread('vozam');
audio = audio';
% Save global values
handles.ispushed = 0;
handles.audio = audio;
handles.fs = fs;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
option = get(hObject,'Tag');
if option == 'radiobutton1'
    %--- Zeus ---%
elseif option == 'radiobutton2'
    %--- Ardilla ---%
elseif option == 'radiobutton3'    
    %--- Eco ---%
    audio = handles.audio;
    fs = handles.fs;
    delay = 0.15;
    decay = 0.6;
    k = zeros(1,delay*fs+2);
    k(1) = decay;
    k(end) = 1-decay;
    result = conv(audio,k);
    handles.result = result;
    guidata(hObject,handles)
elseif option == 'radiobutton4'
    %--- Reverberación ---%
    audio = handles.audio;
    fs = handles.fs;
    k = zeros(1,fs*0.5);
    k(1) = 0.5;
    k(0.1*fs+1) = 0.3;
    k(0.1*fs+1) = 0.1;
    k(0.1*fs+1) = 0.05;
    k(0.1*fs+1) = 0.03;
    result = conv(audio,k);
    handles.result = result;
    guidata(hObject,handles)
elseif option == 'radiobutton5'
    %--- Random ---%
elseif option == 'radiobutton6'
    %--- Vibrato ---%
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
isPushed = handles.ispushed;
isPushed = ~isPushed;
if isPushed
    set(hObject,'String','Detener','ForegroundColor','red');
    result = handles.result;
    fs = handles.fs;
    sound(result,fs);
else
    clear playsnd
    set(hObject,'String','Reproducir','ForegroundColor','green');
end
handles.ispushed = isPushed;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)


% --- Executes during object deletion, before destroying properties.
function pushbutton1_DeleteFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%close
clear playsnd
delete(handles.output);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%less


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
%more
