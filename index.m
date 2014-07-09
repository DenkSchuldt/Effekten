function varargout = index(varargin)
% INDEX MATLAB code for index.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @index_OpeningFcn, ...
                   'gui_OutputFcn',  @index_OutputFcn, ...
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


% --- Executes just before index is made visible.
function index_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.recording = 0;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = index_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
recording = handles.recording;
recording = ~recording;
% Setting parameters
fs = 44100;
n = 16;
id = getfield(getfield(audiodevinfo,'input'),'ID');
% Creating the audiorecorder object
if recording
    set(hObject,'String','Grabando','ForegroundColor','red');
    rec = audiorecorder(fs, n, 1, id);
    record(rec);
    handles.rec = rec;
    handles.recording = recording;
    guidata(hObject,handles);
else
    set(hObject,'String','Grabar audio','ForegroundColor','green');
    stop(handles.rec);
    data = getaudiodata(handles.rec); 
    setappdata(0,'fullpath',data);
    handles.recording = recording;
    guidata(hObject,handles);
    delete(handles.output);
    gui
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
[filename pathname] = uigetfile({'*.wav'},'File Selector');
fullpath = strcat(pathname,filename);
setappdata(0,'fullpath',fullpath);
delete(handles.output);
gui
