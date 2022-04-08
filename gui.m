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

% Last Modified by GUIDE v2.5 06-Dec-2020 09:38:51

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_hitung.
function pushbutton_hitung_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_hitung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get feature vectors
imgpath = 'image_dataset';
nsim = 5;
%nsim = get(handles.popupmenu_imagereturn, 'value');
feature_query = featureVector(handles.Img);
disp(['feature fector for query image has been extracted']);

load('fvect.mat');

imglist = dir(imgpath);
for i=1:size(imglist,1)
    n = imglist(i).name;
    imgname = [imgpath '/' n];
    if (n(1) ~= '.')
        eudist(i,:) = euclid(feature_query, fvect(i,:));
    end
end

% zero should not be choosen, so make it any number biggest
m = max(eudist);

modeudist = zeros(size(eudist,1), 1);
for i=1:size(eudist,1)
    if (eudist(i)==0)
        modeudist(i) = 2*m;
    else
        modeudist(i) = eudist(i);
    end
end

clear i n 
img=cell(1,5);
for i=1:nsim
    % find closest object according to eucledian distance
    idxclosest = find(modeudist == min(modeudist));
    
    %img{i} = imread([imgpath '/' imglist(idxclosest).name])
    img{i}=imread(sprintf([imgpath '/' imglist(idxclosest).name],i));
    ax1 = handles.axes1;
    imshow(img{1},'Parent',ax1);
    ax2 = handles.axes2;
    imshow(img{2},'Parent',ax2);
    ax3 = handles.axes3;
    imshow(img{3},'Parent',ax3);
    ax4 = handles.axes4;
    imshow(img{4},'Parent',ax4);
    ax5 = handles.axes5;
    imshow(img{5},'Parent',ax5);
    
    %figure,
    %imshow(imread([imgpath '/' imglist(idxclosest).name]))
    %title(['closest image rank of ' num2str(i)]);

    modeudist(idxclosest) = m;
end

clear filename idxclosest imagepath imgname imgpath m

% --- Executes on button press in button_direktori.
function button_direktori_Callback(hObject, eventdata, handles)
% hObject    handle to button_direktori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%select direktori gambar
folder_name = uigetdir(pwd, 'Select the directory of images');
if ( folder_name ~= 0 )
    handles.folder_name = folder_name;
    guidata(hObject, handles);
else
    return;
end

% --- Executes on button press in button_feaatureextraction.
function button_feaatureextraction_Callback(hObject, eventdata, handles)
% hObject    handle to button_feaatureextraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles, 'folder_name'))
    errordlg('Please select an image directory first!');
    return;
end

imgpath = fullfile(handles.folder_name);
imglist = dir(imgpath);
for i=1:size(imglist,1)
    n = imglist(i).name;
    imgname = [imgpath '/' n];
    if (n(1) ~= '.')
        imgfind = imread(imgname);
        fvect(i, :) = featureVector(imgfind);
        disp(['feature fector for ' imgname ' has been extracted']);
    end
end
 helpdlg('Dataset Berhasil Diproses');

uisave('fvect','fvect');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_imagereturn.
function popupmenu_imagereturn_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_imagereturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagereturn = get(handles.popupmenu_imagereturn, 'value');
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_imagereturn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_imagereturn


% --- Executes during object creation, after setting all properties.
function popupmenu_imagereturn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_imagereturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_browseimage.
function btn_browseimage_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,~] = uigetfile('*.jpg','Pilih query image');
imagefile = [PathName FileName];
Img = imread(fullfile(PathName,FileName));
    [~,~,m] = size(Img);
if ~isequal(FileName,0)
        axes(handles.axes_query)
        imshow(Img)
        handles.Img = Img;
        guidata(hObject, handles)
end
        
