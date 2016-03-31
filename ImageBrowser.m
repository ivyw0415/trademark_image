function varargout = ImageBrowser(varargin)
% IMAGEBROWSER MATLAB code for ImageBrowser.fig
%      IMAGEBROWSER, by itself, creates a new IMAGEBROWSER or raises the existing
%      singleton*.
%
%      H = IMAGEBROWSER returns the handle to a new IMAGEBROWSER or the handle to
%      the existing singleton*.
%
%      IMAGEBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEBROWSER.M with the given input arguments.
%
%      IMAGEBROWSER('Property','Value',...) creates a new IMAGEBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageBrowser

% Last Modified by GUIDE v2.5 13-May-2015 18:14:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageBrowser_OutputFcn, ...
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


% --- Executes just before ImageBrowser is made visible.
function ImageBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageBrowser (see VARARGIN)

% Choose default command line output for ImageBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile({'*.jpg';'*.bmp'},'Browser');
n=strcat(filepath,filename)
if(~strcmp(filepath,'/Users/wanghan/Desktop/Logo/'))
    copyfile(n,filename);
end

axes(handles.axes1);
imshow(n);
set(handles.edit1,'string',filename);





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = get(handles.edit1,'String');
outN=wavF(n);
axes(handles.axes1);
imshow(n);
axes(handles.axes3);
imshow(outN{1});
axes(handles.axes4);
imshow(outN{2});
axes(handles.axes5);
imshow(outN{3});
axes(handles.axes6);
imshow(outN{4});
axes(handles.axes7);
imshow(outN{5});
axes(handles.axes8);
imshow(outN{6});
axes(handles.axes9);
imshow(outN{7});
axes(handles.axes10);
imshow(outN{8});
axes(handles.axes11);
imshow(outN{9});



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = get(handles.edit1,'String');
outN=snyF(n);
axes(handles.axes1);
imshow(n);
axes(handles.axes3);
imshow(outN{1});
axes(handles.axes4);
imshow(outN{2});
axes(handles.axes5);
imshow(outN{3});
axes(handles.axes6);
imshow(outN{4});
axes(handles.axes7);
imshow(outN{5});
axes(handles.axes8);
imshow(outN{6});
axes(handles.axes9);
imshow(outN{7});
axes(handles.axes10);
imshow(outN{8});
axes(handles.axes11);
imshow(outN{9});
