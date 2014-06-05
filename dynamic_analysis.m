function varargout = dynamic_analysis(varargin)
% DYNAMIC_ANALYSIS MATLAB code for dynamic_analysis.fig
%      DYNAMIC_ANALYSIS, by itself, creates a new DYNAMIC_ANALYSIS or raises the existing
%      singleton*.
%
%      H = DYNAMIC_ANALYSIS returns the handle to a new DYNAMIC_ANALYSIS or the handle to
%      the existing singleton*.
%
%      DYNAMIC_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNAMIC_ANALYSIS.M with the given input arguments.
%
%      DYNAMIC_ANALYSIS('Property','Value',...) creates a new DYNAMIC_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dynamic_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dynamic_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dynamic_analysis

% Last Modified by GUIDE v2.5 07-Apr-2014 11:30:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dynamic_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @dynamic_analysis_OutputFcn, ...
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


% --- Executes just before dynamic_analysis is made visible.
function dynamic_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dynamic_analysis (see VARARGIN)

    if(exist('functions', 'dir'))
        addpath('functions');
    end

    %Checkpoints buffer    
    handles.checkpoint_buff = {};
    handles.checkpoint_names = {};
    handles.checkpoint_files = {};
    
    handles.group_buff = {};
    handles.refgroup_buff = {};
    handles.group_names = {};
    
    handles.index_selected = 1;
    handles.fileind_selected = 1;
    
    %set radiobutton initial state
    set(handles.absoluteConcentration, 'Value',1);
    set(handles.stderror, 'Value',1);
    set(handles.meanPlot, 'Value',1);
    set(handles.plotGrid, 'Value',0);
    % Choose default command line output for dynamic_analysis
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes dynamic_analysis wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dynamic_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addCheckpoint.
function addCheckpoint_Callback(hObject, eventdata, handles)
% hObject    handle to addCheckpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    clear data;
    if(isfield(handles, 'group'))
        set(handles.errorText,'String', '', 'Value',1);
        data = handles.group;
        if (~(isempty(handles.divindex)))
            
            %try if next checkpoint size is equal to previous
            if (size(handles.checkpoint_buff,2)>0)
                temp_size = size(data(handles.divindex,:));
                if(temp_size == handles.checkpoint_size)
                    handles.checkpoint_buff{end+1} = data(handles.divindex,:);
                    handles.checkpoint_size = size(cell2mat(handles.checkpoint_buff(end)));
                    handles.checkpoint_names{end+1} = handles.user_string;
                    handles.checkpoint_files{end+1} = handles.csvfiles(handles.divindex);
                    %intersectFiles(handles);
                    set(handles.checkpointlistbox,'String',handles.checkpoint_names, 'Value',1);
                else
                    disp('Error! Wrong checkpoint size');
                    set(handles.errorText,'String', 'Error! Wrong checkpoint size', 'Value',1);
                    set(handles.errorText,'ForegroundColor','red');
                end               
            else
                handles.checkpoint_buff{end+1} = data(handles.divindex,:);
                handles.checkpoint_size = size(cell2mat(handles.checkpoint_buff(end)));
                handles.checkpoint_names{end+1} = handles.user_string;
                handles.checkpoint_files{end+1} = handles.csvfiles(handles.divindex);
                set(handles.checkpointlistbox,'String',handles.checkpoint_names, 'Value',1);
            end                       
            handles.checkpoint_data = cell2mat(handles.checkpoint_buff);
        end
    else
       set(handles.errorText,'String', 'Data Buffer is empty', 'Value',1);
    end
    guidata(hObject,handles);
    handles

% --- Executes on button press in clearCheckpoint.
function clearCheckpoint_Callback(hObject, eventdata, handles)
% hObject    handle to clearCheckpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.checkpoint_buff = {};
    if (isfield(handles, 'checkpoint_data'))
        handles = rmfield(handles, 'checkpoint_data');
    end
    set(handles.checkpointlistbox,'String','');
    handles.checkpoint_names = {};
    handles.checkpoint_files = {};
    guidata(hObject,handles);
    handles    
    

% --- Executes on button press in clearGroup.
function clearGroup_Callback(hObject, eventdata, handles)
% hObject    handle to clearGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.group_buff = {};
    handles.group_names = {};
    handles.refgroup_buff = {};
    set(handles.grouplistbox,'String','');    
    guidata(hObject,handles);
    handles  

% --- Executes on button press in clearData.
function clearData_Callback(hObject, eventdata, handles)
% hObject    handle to clearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %clear all axes
    
    if(isfield(handles, 'file_names'))
        set(handles.mylistbox,'String',handles.file_names, 'Value',0)
        set(handles.mylistbox,'String','');
    end
    if (isfield(handles, 'csvfiles'))
        handles = rmfield(handles, 'csvfiles');
    end
    set(handles.divfiles,'String', '0');
    handles.metabolites = []; 
	handles.num_metabolite = 0;
    clear data;
    if(isfield(handles, 'group'))
        handles = rmfield(handles, 'group');
    end
    if(isfield(handles, 'reference'))
        handles = rmfield(handles, 'reference');
    end
    if(isfield(handles, 'crb'))
        handles = rmfield(handles, 'crb');
    end
    set(handles.listboxtext,'String', '');
    
    clearFigures_Callback(hObject, eventdata, handles);
    clearCheckpoint_Callback(hObject, eventdata, handles);
    clearGroup_Callback(hObject, eventdata, handles);
    %set handles
    guidata(hObject,handles);
    handles   

% --- Executes on button press in clearFigures.
function clearFigures_Callback(hObject, eventdata, handles)
% hObject    handle to clearFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %clear all axes
    arrayfun(@cla,findall(0,'type','axes')) ;
    

% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    arrayfun(@cla,findall(0,'type','axes'));
    
    handles.divindex = [];
    set(handles.divfiles,'String', '0');
    set(handles.divisionField,'String', 'Type checkpoint pattern');
    handles.metabolites = []; 
	handles.num_metabolite = 0;
    if(isfield(handles, 'group'))
        handles = rmfield(handles, 'group');
    end
    if(isfield(handles, 'reference'))
        handles = rmfield(handles, 'reference');
    end
    if(isfield(handles, 'crb'))
        handles = rmfield(handles, 'crb');
    end

	te = 20;
    script_path = pwd;
    
    %get csvdata directory
    dir_path = uigetdir('dialog_title', 'Select a directory with csv files');
    if dir_path
        cd (dir_path);
        dir_struct = dir(dir_path);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        handles.file_names = sorted_names;
        handles.is_dir = [dir_struct.isdir];
        handles.sorted_index = sorted_index;
        guidata(handles.figure1,handles)

        %set filenames in the gui listbox
        set(handles.mylistbox,'String',handles.file_names, 'Value',1);
        set(handles.listboxtext,'String',pwd);

        % read csv files
        cd (script_path);
        csvfiles = dir(strcat(dir_path,'/*.csv'));
        if(length(csvfiles)>0)
            [name index num_files met met_files crb]=readcsv(dir_path);
            handles.num_patient = num_files;
            handles.metabolites = name;
            handles.num_metabolite = numel(handles.metabolites);
            handles.group = met;
            handles.crb = crb;
            handles.index = index;
            handles.csvfiles = met_files;

            %find PC+Cr index
            handles.refindex = strmatch('Cr+PCr', name, 'exact');
            handles.reference = met(:, handles.refindex); 

        end  
        
        %set metabolites in the gui listbox
        set(handles.metabolitelistbox,'String',handles.metabolites, 'Value',1);
        set(handles.checkpointlistbox,'String','');
        handles.checkpoint_names = {};
        handles.checkpoint_files = {};
        handles.checkpoint_buff = {};
    end
    %set handles
    guidata(hObject,handles);
    handles

function intersectFiles(handles)
    clear data;
    data = handles.checkpoint_files;
    for i=1:size(data,2)
        clear files;
        files = cell2mat(data(i))
        clear temp;
        temp = intersect(files(1).name, files(1).name, 'stable');
        for i=1:size(files, 1)
            temp = intersect(temp, files(i).name, 'stable')
        end
    end
  
    
% --- Executes on button press in plotGroup.
function plotGroup_Callback(hObject, eventdata, handles)
% hObject    handle to plotGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in addGroup.
    if(isfield(handles, 'group_buff'))
        hold(handles.axes1, 'off');
        group_size = size(handles.group_buff,2);
        h = zeros(3,3);
        kcolor = ['g', 'r', 'b', 'm', 'y'];
        for i=1:group_size
            clear reshaped_data;
            clear reference_data;
            clear plot_data;
            clear scaled_data;
            reshaped_data = cell2mat(handles.group_buff(i));
            reference_data = cell2mat(handles.refgroup_buff(i));
            plot_data = squeeze(reshaped_data(:,handles.index_selected,:));
            scaled_data = plot_data./reference_data;          
            if(get(handles.scaledConcentration,'Value')==1)
                if(get(handles.eachPlot, 'Value')==1)
                    plot(handles.axes1, scaled_data', 'color', kcolor(i));
                end
                if(get(handles.meanPlot, 'Value')==1)
                    meanvalue = mean(scaled_data, 1);
                    stdvalue = std(scaled_data, 0,1);
                    stderror = stdvalue/sqrt(size(handles.divindex,2));
                    plot(handles.axes1, meanvalue,  'color', kcolor(i));
                    
                    if(get(handles.stddev, 'Value') ==1)
                        e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stdvalue, 'color',kcolor(i));
                    end
                    if(get(handles.stderror, 'Value') ==1)
                        e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stderror, 'color',kcolor(i));
                    end
                end
                ylabel(handles.axes1, 'Concentration / (Cr+PCr)'); 
                if(get(handles.plotGrid,'Value')==1)
                    grid(handles.axes1, 'on');
                end
                if(get(handles.plotGrid,'Value')==0)
                    grid(handles.axes1, 'off');
                end
            end
            if(get(handles.absoluteConcentration,'Value')==1)
                if(get(handles.eachPlot, 'Value')==1)
                    plot(handles.axes1, plot_data', 'color',kcolor(i));
                end
                if(get(handles.meanPlot, 'Value')==1)
                    meanvalue = mean(plot_data, 1);
                    stdvalue = std(plot_data, 0,1);
                    stderror = stdvalue/sqrt(size(handles.divindex,2));
                    plot(handles.axes1, meanvalue, 'color',kcolor(i));
                    if(get(handles.stddev, 'Value') ==1)
                        e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stdvalue, 'color',kcolor(i));
                    end
                    if(get(handles.stderror, 'Value') ==1)
                        e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stderror, 'color',kcolor(i));
                    end
                end
                ylabel(handles.axes1, 'Absolute concentration'); 
                if(get(handles.plotGrid,'Value')==1)
                    grid(handles.axes1, 'on');
                end
                if(get(handles.plotGrid,'Value')==0)
                    grid(handles.axes1, 'off');
                end                
            end

            [legend_h,object_h,plot_h,text_strings] = legend(handles.group_names(1:i));
            %Add legend
            h=legend(handles.group_names(1:i));

            %Set line of legend in red
            leg_line=findobj(h,'type','Line')
            x =1;
            for p = 1:length(plot_h)
                 set(leg_line(x), 'Color', kcolor(p));
                 x = x+2;
            end
   
            
            set(handles.axes1, 'xTick', 1:size(handles.checkpoint_names,2));
            %set(handles.axes1, 'xticklabel', handles.checkpoint_names, 'fontsize', 12); meanvalue, 'color',[rand(1),rand(1),rand(1)]);
            if(get(handles.stddev, 'Value') ==1)
                e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stdvalue, 'color',kcolor(i));
            end
            if(get(handles.stderror, 'Value') ==1)
                e = errorbar(handles.axes1,1:size(stdvalue,2),meanvalue, stderror, 'color',kcolor(i));
            end            
            hold(handles.axes1, 'on');
            pause(1)
            
        end
        ylabel(handles.axes1, 'Absolute concentration'); 
        if(get(handles.plotGrid,'Value')==1)
            grid(handles.axes1, 'on');
        end
        if(get(handles.plotGrid,'Value')==0)
            grid(handles.axes1, 'off');
        end

    end
    
    set(handles.axes1, 'xTick', 1:size(handles.checkpoint_names,2));
    guidata(hObject,handles);
    handles
    %set(handles.axes1, 'xticklabel', handles.checkpoint_names, 'fontsize', 12);


function addGroup_Callback(hObject, eventdata, handles)
% hObject    handle to addGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
    clear reshaped_data;
    clear plot_data;
    clear reference_data;
    clear scaled_data;
    clear meanvalue;
    clear stdvalue;
    
    if(isfield(handles,'checkpoint_data'))             
        reshaped_data = reshape(handles.checkpoint_data, [size(handles.checkpoint_data,1) handles.num_metabolite size(handles.checkpoint_data,2)/handles.num_metabolite ]);
        handles.group_buff(end+1) = {reshaped_data};
        handles.group_names(end+1) = {handles.user_string2};
        
        set(handles.grouplistbox,'String',handles.group_names, 'Value',1);
        reference_data = squeeze(reshaped_data(:,handles.refindex,:));       
        handles.refgroup_buff(end+1) = {reference_data};

        
    end
    guidata(hObject,handles);
    handles
% --- Executes on selection change in mylistbox.
function mylistbox_Callback(hObject, eventdata, handles)
% hObject    handle to mylistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mylistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mylistbox
    % if left click mouse
    if strcmp(get(handles.figure1,'SelectionType'),'normal')
        fileind_selected = get(handles.mylistbox,'Value');
        handles.fileind_selected = fileind_selected;
        handles.file_names(fileind_selected);
        % Item selected in list box
        %handles.met_selected = {met_list{index_selected}};
        guidata(hObject,handles);
    end
    handles

% --- Executes during object creation, after setting all properties.
function mylistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mylistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in checkpointlistbox.
function checkpointlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkpointlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns checkpointlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from checkpointlistbox
    % If double click


% --- Executes during object creation, after setting all properties.
function checkpointlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkpointlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in metabolitelistbox.
function metabolitelistbox_Callback(hObject, eventdata, handles)
% hObject    handle to metabolitelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns metabolitelistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metabolitelistbox
    % If double click
    if strcmp(get(handles.figure1,'SelectionType'),'open')
        index_selected = get(handles.metabolitelistbox,'Value');
        handles.index_selected = index_selected;
        met_list = get(handles.mylistbox,'String');
        % Item selected in list box
        %handles.met_selected = {met_list{index_selected}};
        plotGroup_Callback(hObject, eventdata, handles);
        guidata(hObject,handles);
    end

% --- Executes during object creation, after setting all properties.
function metabolitelistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metabolitelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grouplistbox.
function grouplistbox_Callback(hObject, eventdata, handles)
% hObject    handle to grouplistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grouplistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grouplistbox


% --- Executes during object creation, after setting all properties.
function grouplistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grouplistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function divisionField_Callback(hObject, eventdata, handles)
% hObject    handle to divisionField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of divisionField as text
%        str2double(get(hObject,'String')) returns contents of divisionField as a double

    handles.user_string = get(hObject,'String');
    if(isfield(handles, 'csvfiles'))
        x = {handles.csvfiles.name};
        y = handles.user_string;
        %divide user string by ';'
        divstrings= {} ; 
        while ~isempty(y),
              [divstrings{end+1}, y] = strtok(y, ';') ;
        end
        
        %eradicate white signs
        divstrings = strrep(divstrings, ' ', '');
        
        %find all file's index that fit to user string
        index_temp = 1:size(x,2);
        for i=1:size(divstrings,2)
            index_temp = intersect(index_temp, find(~cellfun(@isempty, strfind(x, cell2mat(divstrings(i))))));            
        end
        handles.divindex = index_temp;
        set(handles.divfiles,'String', num2str(size(handles.divindex,2)*size(handles.divindex,1)));
    end
    guidata(hObject,handles);
    handles

% --- Executes during object creation, after setting all properties.
function divisionField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to divisionField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function groupNameField_Callback(hObject, eventdata, handles)
% hObject    handle to groupNameField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of groupNameField as text
%        str2double(get(hObject,'String')) returns contents of groupNameField as a double
    handles.user_string2 = get(hObject,'String');
    guidata(hObject,handles);
    handles


% --- Executes during object creation, after setting all properties.
function groupNameField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupNameField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in absoluteConcentration.
function absoluteConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to absoluteConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of absoluteConcentration
    if(get(hObject,'Value')==1) set(handles.scaledConcentration, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles);
    

% --- Executes on button press in scaledConcentration.
function scaledConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to scaledConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scaledConcentration
    if(get(hObject,'Value')==1) set(handles.absoluteConcentration, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles);
   

% --------------------------------------------------------------------
% open figure in new window
function plot_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Create a figure to receive this axes' data
    axes1fig = figure;
    % Copy the axes and size it to the figure
    axes1copy = copyobj(handles.axes1,axes1fig);
    set(axes1copy,'Units','Normalized', 'Position',[.05,.20,.90,.60])
    % Assemble a title for this new figure
    % Save handles to new fig and axes in case
    % we want to do anything else to them
    %handles.axes1fig = axes1fig;
    %handles.axes1 = axes1copy;
    cla(handles.axes1);
    guidata(hObject,handles);
    
% --------------------------------------------------------------------
function plot_ax1_clear_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax1_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     cla(handles.axes1);

% --------------------------------------------------------------------
function plot_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in meanPlot.
function meanPlot_Callback(hObject, eventdata, handles)
% hObject    handle to meanPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of meanPlot
    if(get(hObject,'Value')==1) set(handles.eachPlot, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles)

% --- Executes on button press in eachPlot.
function eachPlot_Callback(hObject, eventdata, handles)
% hObject    handle to eachPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eachPlot
    if(get(hObject,'Value')==1) set(handles.meanPlot, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles);


% --- Executes on button press in plotGrid.
function plotGrid_Callback(hObject, eventdata, handles)
% hObject    handle to plotGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotGrid
    
    if(get(hObject,'Value')==1)
        grid(handles.axes1, 'on');
    end
    if(get(hObject,'Value')==0)
        grid(handles.axes1, 'off');
    end


% --- Executes on button press in stddev.
function stddev_Callback(hObject, eventdata, handles)
% hObject    handle to stddev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of stddev
    if(get(hObject,'Value')==1) set(handles.stderror, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles);

% --- Executes on button press in stderror.
function stderror_Callback(hObject, eventdata, handles)
% hObject    handle to stderror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stderror
    if(get(hObject,'Value')==1) set(handles.stddev, 'Value',0); end;
    plotGroup_Callback(hObject, eventdata, handles);


% --- Executes on button press in exportFiles.
function exportFiles_Callback(hObject, eventdata, handles)
% hObject    handle to exportFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename,pathname] = uiputfile('*.csv', 'Save file as');
    if filename
        if(isfield(handles, 'group'))
            set(handles.errorText,'String', '', 'Value',1);
            data_cell = cell(1,1);
            data_cell(1,2:size(handles.metabolites)+1) = handles.metabolites;
            data_cell(2:size(handles.csvfiles)+1,1) = handles.file_names(3:end);
            if(get(handles.scaledConcentration,'Value')==1)
                data_cell(2:end, 2:end) = num2cell(bsxfun(@rdivide, handles.group, handles.reference));
                data_cell(1,1) = {'scaled concetration to Cr+PCr'};
                cell2csv(strcat(pathname, '/', filename), data_cell, ';');
            end
            if(get(handles.absoluteConcentration,'Value')==1)
                data_cell(2:end, 2:end) = num2cell(handles.group);
                data_cell(1,1) = {'absolute concentration'};
                cell2csv(strcat(pathname, '/', filename), data_cell, ';');
            end
            handles
        else
            set(handles.errorText,'String', 'Error! Data buffer is empty', 'Value',1);
            set(handles.errorText,'ForegroundColor','red');
        end
    end


% --------------------------------------------------------------------
% remove file from right click mouse menu
function remove_file_Callback(hObject, eventdata, handles)
% hObject    handle to remove_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(isfield(handles, 'group'))
        if(handles.fileind_selected > 2)
            handles.group(handles.fileind_selected-2, :) = [];
            handles.reference(handles.fileind_selected-2, :) = [];
            handles.crb(handles.fileind_selected-2, :) = [];
            handles.csvfiles(handles.fileind_selected-2) = [];
            handles.file_names(handles.fileind_selected)
            handles.file_names(handles.fileind_selected) = [];
            handles.num_patient = handles.num_patient-1;
            set(handles.mylistbox,'String',handles.file_names, 'Value',1);
        end
        
    end
    guidata(hObject,handles);
    handles

% --------------------------------------------------------------------
function listbox_rightclick_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_rightclick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
