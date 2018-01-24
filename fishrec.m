function varargout = fishrec(varargin)
% FISHREC MATLAB code for fishrec.fig
%      FISHREC, by itself, creates a new FISHREC or raises the existing
%      singleton*.
%
%      H = FISHREC returns the handle to a new FISHREC or the handle to
%      the existing singleton*.
%
%      FISHREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FISHREC.M with the given input arguments.
%
%      FISHREC('Property','Value',...) creates a new FISHREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fishrec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fishrec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fishrec

% Last Modified by GUIDE v2.5 01-Apr-2016 15:09:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fishrec_OpeningFcn, ...
                   'gui_OutputFcn',  @fishrec_OutputFcn, ...
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


% --- Executes just before fishrec is made visible.
function fishrec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fishrec (see VARARGIN)

% Choose default command line output for fishrec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fishrec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fishrec_OutputFcn(hObject, eventdata, handles) 
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
[filename pathname]=uigetfile('*.jpg;*.bmp;*.jpeg;*.png;','select an image');
imgname=[pathname filename];
axes(handles.axes1)
imshow(imgname);



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
img=getimage(handles.axes1);
tiger = histeq(rgb2gray(img));
% Downsample, just to avoid dealing with high?res images.
tiger = im2double(imresize(tiger, [240 320]));
tiger = wiener2(tiger,[10 10]);
%imshow(tiger);
d = im2bw(tiger);
E = edge(d, 'canny');
%figure; imshow(d), title('edges');
IM2 = imfill(imcomplement(d),'holes');
%figure; imshow(IM2), title('thresh');
BW2 = bwareaopen(IM2, 500);
%figure; imshow(BW2), title('with objects removed');
parameters = regionprops(BW2,'Area','EulerNumber','Orientation','Extent','Perimeter','ConvexArea','Solidity','Eccentricity','MajorAxisLength' ,'EquivDiameter','MinorAxisLength');
features = cell2mat(struct2cell(parameters)); 
load('net.mat');
testY = net(features);
testIndices = vec2ind(testY);
switch(testIndices)
    case 1
        f = 'African Carp';
    case 2
        f = 'Butter Fish';
    case 3
        f = 'Climbing Perch';
    case 4
        f = 'Marble Catfish';
    case 5
        f = 'Mackerel';
    case 6
        f = 'Silver Catfish';
    case 7
        f = 'Moon Fish';
    case 8
        f = 'Tilapia';
    case 9
        f = 'Reed Fish';
    case 10
        f = 'Cray Fish';
    case 11
        f = 'Elephant Nose Fish';
    case 12
        f = 'Flat Fish';
    case 13
        f = 'Mormyrops';
    case 14
        f = 'African Pike';
    case 15
        f = 'Sardine';
end
set(handles.edit1, 'string', f);
