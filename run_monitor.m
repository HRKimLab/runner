function varargout = run_monitor(varargin)
% RUN_MONITOR MATLAB code for run_monitor.fig
%      RUN_MONITOR, by itself, creates a new RUN_MONITOR or raises the existing
%      singleton*.
%
%      H = RUN_MONITOR returns the handle to a new RUN_MONITOR or the handle to
%      the existing singleton*.
%
%      RUN_MONITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_MONITOR.M with the given input arguments.
%
%      RUN_MONITOR('Property','Value',...) creates a new RUN_MONITOR or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_monitor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_monitor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_monitor

% Last Modified by GUIDE v2.5 13-Jan-2014 22:42:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_monitor_OpeningFcn, ...
                   'gui_OutputFcn',  @run_monitor_OutputFcn, ...
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


% --- Executes just before run_monitor is made visible.
function run_monitor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_monitor (see VARARGIN)

% Choose default command line output for run_monitor
handles.output = hObject;

% handles.timer = timer(...
%     'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
%     'Period', 1, ...                % Initial period is 1 sec.
%     'TimerFcn', {@update_display,hObject}); % Specify callback


% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes run_monitor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_monitor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RunnerDefs;

disp('Monitoring started');
set(handles.calculate,'ForegroundColor',[0 1 0])

while all(get(handles.calculate,'ForegroundColor') == [0 1 0])

    % read .m files
    cStrM = cellfun(@(x) fullfile(x, '*.m'), JOB_DIR,'UniformOutput',false);
    cDirM = cellfun(@dir, cStrM,'UniformOutput',false);
    nMPerMachine = cellfun(@length, cDirM,'UniformOutput',false);
        
    % read .fail files
    cStrM = cellfun(@(x) fullfile(x, '*.fail'), JOB_DIR,'UniformOutput',false);
    cDirM = cellfun(@dir, cStrM,'UniformOutput',false);
    nFailPerMachine = cellfun(@length, cDirM,'UniformOutput',false);

    % read .done files
    cStrM = cellfun(@(x) fullfile(x, '*.done'), JOB_DIR,'UniformOutput',false);
    cDirM = cellfun(@dir, cStrM,'UniformOutput',false);
    nDonePerMachine = cellfun(@length, cDirM,'UniformOutput',false);
    
    set(handles.dash_table, 'Data', [MACHINE_ID' JOB_DIR' nMPerMachine' nFailPerMachine' nDonePerMachine']);

    % read .txt files
    cStrM = cellfun(@(x) fullfile(x, '*.txt'), JOB_DIR,'UniformOutput',false);
    cDirM = cellfun(@dir, cStrM,'UniformOutput',false);

    for iD=1:length(cDirM)
        for iF=1:length(cDirM{iD})
            cDirM{iD}(iF).fpath = fullfile(JOB_DIR{iD}, cDirM{iD}(iF).name);
        end
        if isempty(cDirM{iD})
            cDirM{iD} = [];
        end
    end
    arDirM = cat(1,cDirM{:});
    if isempty(arDirM)
        cL = {'No log file detected'};
    else % show content of the latest log file
        [tmp iMax] = max(cat(1,arDirM.datenum));
        arDirM(iMax).fpath
        fid=fopen(arDirM(iMax).fpath);
        cL={}; cL{1} = arDirM(iMax).fpath;
        cL{2} = fgets(fid);
        while(cL{end} ~= -1)
            cL{end+1} = fgets(fid);
        end
        fclose(fid); cL(end) = [];
    end
    set(handles.listbox2,'string',cL);
    
    pause(20);
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% data = guidata(handles.calculate)
% data.do_monitor = 0;
% guidata(handles.calculate, data);

set(handles.calculate,'ForegroundColor',[0 0 0])
initialize_gui(gcbf, handles, true);
disp('Monitoring stopped'); 

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

RunnerDefs;

set(handles.dash_table, 'ColumnName',{'Name','Directory','Queue','Fail','Done'});
set(handles.dash_table,'columnwidth',{100, 100, 40, 40, 40})
set(handles.dash_table, 'Data', [MACHINE_ID' JOB_DIR']);
% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in pushbutton_clear_all.
function pushbutton_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dispatcher('clear','all');

% --- Executes on button press in pushbutton_clear_fail.
function pushbutton_clear_fail_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_fail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispatcher('clearfail','all')


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
