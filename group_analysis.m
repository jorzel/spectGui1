function varargout = group_analysis(varargin)
% GROUP_ANALYSIS MATLAB code for group_analysis.fig
%      GROUP_ANALYSIS, by itself, creates a new GROUP_ANALYSIS or raises the existing
%      singleton*.
%
%      H = GROUP_ANALYSIS returns the handle to a new GROUP_ANALYSIS or the handle to
%      the existing singleton*.
%
%      GROUP_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUP_ANALYSIS.M with the given input arguments.
%
%      GROUP_ANALYSIS('Property','Value',...) creates a new GROUP_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before group_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to group_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help group_analysis

% Last Modified by GUIDE v2.5 24-Apr-2014 17:30:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @group_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @group_analysis_OutputFcn, ...
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


% --- Executes just before group_analysis is made visible.
function group_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to group_analysis (see VARARGIN)


    % Choose default command line output for group_analysis
    handles.output = hObject;

    % initial radiobutton and textfields state
    set(handles.stdev, 'Value',1);
    set(handles.fullmetset, 'Value',1);
    set(handles.scaledConcentration, 'Value',1);

    set(handles.firstdivfiles,'String', '0');
    set(handles.seconddivfiles,'String', '0');

    handles.firstdivindex = [];
    handles.seconddivindex = [];
    handles.coordflag = 0;
    handles.tableflag = 0;
    
    
    if(exist('functions', 'dir'))
        addpath('functions');
    end


    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes group_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = group_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in calcMean.
function calcMean_Callback(hObject, eventdata, handles)
% hObject    handle to calcMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %cla(handles.axes1, 'reset');
    clear data;    
    if(isfield(handles, 'group_mean'))
        handles = rmfield(handles, 'group_mean');
    end
    if(isfield(handles, 'group_sd'))
        handles = rmfield(handles, 'group_sd');
    end
    if(isfield(handles, 'std_error'))
        handles = rmfield(handles, 'std_error');
    end
    if(isfield(handles, 'group'));
        
        %check concentration radio button state
        if(get(handles.scaledConcentration,'Value')==1)
            data = bsxfun(@rdivide, handles.group, handles.reference); 
            ylabel(handles.axes2, 'Concentration / (Cr+PCr)'); 
        end
        if(get(handles.scaledConcentrationGPC,'Value')==1)
            data = bsxfun(@rdivide, handles.group, handles.reference2); 
            ylabel(handles.axes2, 'Concentration / (GPC+PCh)'); 
        end
        if(get(handles.absoluteConcentration,'Value')==1)
            data = handles.group;
            ylabel(handles.axes2, 'Absolute concentration'); 
        end
        
        %check the state of user string fields
        if (~(isempty(handles.firstdivindex)) && (isempty(handles.seconddivindex))) 
            disp('nr2');
            handles.group_mean(:,1) = mean(data(handles.firstdivindex, :),1);
            handles.group_sd(:,1) = std(data(handles.firstdivindex, :),0,1);
            handles.std_error(:,1) = std(data(handles.firstdivindex, :),0,1)/sqrt(size(handles.firstdivindex,2));
        elseif (isempty(handles.firstdivindex) && ~(isempty(handles.seconddivindex))) 
            disp('nr3');
            handles.group_mean(:,1) = mean(data(handles.seconddivindex, :),1);
            handles.group_sd(:,1) = std(data(handles.seconddivindex, :),0,1);
            handles.std_error(:,1) = std(data(handles.seconddivindex, :),0,1)/sqrt(size(handles.seconddivindex,2));
        elseif (~(isempty(handles.firstdivindex)) && ~(isempty(handles.seconddivindex)))
            if(isfield(handles, 'group_mean'))
                handles = rmfield(handles, 'group_mean');
            end
            if(isfield(handles, 'group_sd'))
                handles = rmfield(handles, 'group_sd');
            end
            if(isfield(handles, 'std_error'))
                handles = rmfield(handles, 'std_error');
            end
            disp('nr4');
            handles.group_mean(:,1) = mean(data(handles.firstdivindex, :),1);
            handles.group_sd(:,1) = std(data(handles.firstdivindex, :),0,1);
            handles.std_error(:,1) = std(data(handles.firstdivindex, :),0,1)/sqrt(size(handles.firstdivindex,2));
            
            handles.group_mean(:,2) = mean(data(handles.seconddivindex, :),1);
            handles.group_sd(:,2) = std(data(handles.seconddivindex, :),0,1);        
            handles.std_error(:,2) = std(data(handles.seconddivindex, :),0,1)/sqrt(size(handles.seconddivindex,2));
        else
            disp('nr1');
            handles.group_mean(:,1) = mean(data,1);
            handles.group_sd(:,1) = std(data,0,1);
            handles.std_error(:,1) = (std(data,0,1)/sqrt(handles.num_patient));
        end
        
        %check metaboliteset radio button
        if(get(handles.fullmetset,'Value')==1)
            if(isfield(handles, 'metabolites'))
                x = 1:numel(handles.metabolites);
            end
            
            if(get(handles.stdev,'Value')==1)
                if(~isempty(handles.firstdivindex) && ~(isempty(handles.seconddivindex)))
                    e1 = errorbar(handles.axes2,x-0.1 , handles.group_mean(:,1), handles.group_sd(:,1), 'r.');
                    hold(handles.axes2, 'on')
                    e2 = errorbar(handles.axes2,x+0.1 , handles.group_mean(:,2), handles.group_sd(:,2), 'r.');
                else                   
                    e1 = errorbar(handles.axes2,x , handles.group_mean, handles.group_sd, 'r.');
                end
                hold(handles.axes2, 'on')
            end
            if(get(handles.stderror,'Value')==1)
                if(~isempty(handles.firstdivindex) && ~(isempty(handles.seconddivindex)))
                    e1 = errorbar(handles.axes2,x-0.1 , handles.group_mean(:,1), handles.std_error(:,1), 'r.');
                    hold(handles.axes2, 'on')
                    e2 = errorbar(handles.axes2,x+0.1 , handles.group_mean(:,2), handles.std_error(:,2), 'r.');
                else                   
                    e1 = errorbar(handles.axes2,x , handles.group_mean, handles.std_error, 'r.');
                end
                hold(handles.axes2, 'on')
            end
            p = bar(handles.axes2,handles.group_mean);
            legend(p,handles.user_string1,handles.user_string2);
            set(handles.axes2, 'xTick', x);
            set(handles.axes2,'xticklabel', handles.metabolites, 'fontsize', 12);
            rotateXLabels(handles.axes2,-90);
        end
        
        if(get(handles.indmetset,'Value')==1)
            if(isfield(handles, 'metabolites'))
                x = 1:numel(handles.metabolites(handles.index));
            end
                        
            if(get(handles.stdev,'Value')==1)
                if(~isempty(handles.firstdivindex) && ~(isempty(handles.seconddivindex)))
                    e1 = errorbar(handles.axes2,x-0.15 , handles.group_mean(handles.index,1), handles.group_sd(handles.index,1), 'r.');
                    hold(handles.axes2, 'on')
                    e2 = errorbar(handles.axes2,x+0.15 , handles.group_mean(handles.index,2), handles.group_sd(handles.index,2), 'r.');
                else                   
                    e1 = errorbar(handles.axes2,x , handles.group_mean(handles.index), handles.group_sd(handles.index), 'r.');
                end
                hold(handles.axes2, 'on')
            end
            if(get(handles.stderror,'Value')==1)
                if(~isempty(handles.firstdivindex) && ~(isempty(handles.seconddivindex)))
                    e1 = errorbar(handles.axes2,x-0.15 , handles.group_mean(handles.index,1), handles.std_error(handles.index,1), 'r.');
                    hold(handles.axes2, 'on')
                    e2 = errorbar(handles.axes2,x+0.15 , handles.group_mean(handles.index,2), handles.std_error(handles.index,2), 'r.');
                else                   
                    e1 = errorbar(handles.axes2,x , handles.group_mean(handles.index, :), handles.std_error(handles.index, :), 'r.');
                end
                hold(handles.axes2, 'on')
            end
            p = bar(handles.axes2,handles.group_mean(handles.index, :));
            legend(p,handles.user_string1,handles.user_string2);
            set(handles.axes2, 'xTick', x);
            set(handles.axes2,'xticklabel', handles.metabolites(handles.index), 'fontsize', 12);
            rotateXLabels(handles.axes2,-90);
        end
        ylim(handles.axes2, [0 inf]);
        if(get(handles.scaledConcentration,'Value')==1)
            ylabel(handles.axes2, 'Concentration / (Cr+PCr)'); 
        end
        if(get(handles.scaledConcentrationGPC,'Value')==1)
            ylabel(handles.axes2, 'Concentration / (GPC+PCh)'); 
        end
        if(get(handles.absoluteConcentration,'Value')==1)
            ylabel(handles.axes2, 'Absolute concentration'); 
        end
        hold(handles.axes2, 'off');
        guidata(hObject,handles);
    end
    handles;    

% --- Executes on button press in clearData.
function clearData_Callback(hObject, eventdata, handles)
% hObject    handle to clearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %clear all axes
    arrayfun(@cla,findall(0,'type','axes'));

    handles.firstdivindex = [];
    handles.seconddivindex = [];
    set(handles.firstdivfiles,'String', '0');
    set(handles.seconddivfiles,'String', '0');
    set(handles.firstDivision,'String', 'First group pattern');
    set(handles.secondDivision,'String', 'Second group pattern');
    handles.user_string1 = '';
    handles.user_string2 = '';
    
    if(isfield(handles, 'file_names'))
        set(handles.mylistbox,'String',handles.file_names, 'Value',0)
        set(handles.mylistbox,'String','');
    end
    handles.metabolites = []; 
    handles.index = [];
	handles.num_metabolite = 0;
    handles.num_patient = 0;
    clear data;
    if(isfield(handles, 'group'))
        handles = rmfield(handles, 'group');
    end
    if(isfield(handles, 'reference'))
        handles = rmfield(handles, 'reference');
    end
    if(isfield(handles, 'reference2'))
        handles = rmfield(handles, 'reference2');
    end
    if(isfield(handles, 'fit'))
        handles = rmfield(handles, 'fit');
    end
    if(isfield(handles, 'ppm'))
        handles = rmfield(handles, 'ppm');
    end
    if(isfield(handles, 'spectrum'))
        handles = rmfield(handles, 'spectrum');
    end
    if(isfield(handles, 'crb'))
        handles = rmfield(handles, 'crb');
    end
    if(isfield(handles, 'snr'))
        handles = rmfield(handles, 'snr');
    end
    if(isfield(handles, 'fwhm'))
        handles = rmfield(handles, 'fwhm');
    end
    if(isfield(handles, 'group_mean'))   
        handles = rmfield(handles, 'group_mean');
    end
    if(isfield(handles, 'group_sd'))
        handles = rmfield(handles, 'group_sd');
    end
    if(isfield(handles, 'std_error'))
        handles = rmfield(handles, 'std_error');
    end
    if(isfield(handles, 'coordfiles'))
        handles = rmfield(handles, 'coordfiles');
    end
    if(isfield(handles, 'csvfiles'))
        handles = rmfield(handles, 'csvfiles');
    end
    if(isfield(handles, 'tablefiles'))
        handles = rmfield(handles, 'tablefiles');
    end
    set(handles.listboxtext,'String', '');
    
    %set handles
    guidata(hObject,handles);
    handles     

% --- Executes on button press in clearFigure.
function clearFigure_Callback(hObject, eventdata, handles)
% hObject    handle to clearFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %clear all axes
    arrayfun(@cla,findall(0,'type','axes')) ;
  
    
% --- Function which draw Metabolites bar for selected file    
function drawBar(handles)
    if(isfield(handles, 'group'))
        clear data;legend
        if(get(handles.scaledConcentration,'Value')==1)
            data = bsxfun(@rdivide, handles.group, handles.reference); 
            ylabel(handles.axes1, 'Concentration / (Cr+PCr)'); 
        end
        if(get(handles.scaledConcentrationGPC,'Value')==1)
            data = bsxfun(@rdivide, handles.group, handles.reference2); 
            ylabel(handles.axes1, 'Concentration / (GPC+PCh)'); 
        end
        if(get(handles.absoluteConcentration,'Value')==1)
            data = handles.group;
            ylabel(handles.axes1, 'Absolute concentration'); 
        end
        crb = (data.*handles.crb)./100;  
    end
    if(isfield(handles, 'index_selected'))
        if(get(handles.fullmetset,'Value')==1)
            x = 1:numel(handles.metabolites);
            e1 = errorbar(handles.axes1,x , data(handles.index_selected-2,:), crb(handles.index_selected-2,:), 'r.');
            hold(handles.axes1, 'on')
            handles.barfigure=bar(handles.axes1,data(handles.index_selected-2,:));
            set(handles.axes1, 'xTick', x);
            set(handles.axes1,'xticklabel', handles.metabolites, 'fontsize', 12);
            rotateXLabels(handles.axes1,-90);
        end
        if(get(handles.indmetset,'Value')==1)
            x = 1:numel(handles.metabolites(handles.index));
            e1 = errorbar(handles.axes1,x , data(handles.index_selected-2,handles.index), crb(handles.index_selected-2,handles.index), 'r.');
            hold(handles.axes1, 'on')
            handles.barfigure=bar(handles.axes1,data(handles.index_selected-2,handles.index));
            set(handles.axes1, 'xTick', x);
            set(handles.axes1,'xticklabel', handles.metabolites(handles.index), 'fontsize', 12);
            rotateXLabels(handles.axes1,-90);  
        end
    end
    if(get(handles.scaledConcentration,'Value')==1)
        ylabel(handles.axes1, 'Concentration / (Cr+PCr)'); 
    end
    if(get(handles.scaledConcentrationGPC,'Value')==1)
        ylabel(handles.axes1, 'Concentration / (GPC+PCh)'); 
    end
    if(get(handles.absoluteConcentration,'Value')==1)
        ylabel(handles.axes1, 'Absolute concentration'); 
    end
    ylim(handles.axes1, [0 inf]);
    hold(handles.axes1, 'off');

    
function drawPlot(handles)
    disp('pierwszy')
    if(isfield(handles, 'ppm') && isfield(handles, 'spectrum'))
        disp('drugi')
        zeroline = zeros(size(handles.ppm));
        plot(handles.axes3, handles.ppm(:,handles.coordind)*(-1), handles.spectrum(:, handles.coordind));
        hold(handles.axes3, 'on');
        %plot(handles.axes3, zeroline, '--');

    end
    if(isfield(handles, 'ppm') && isfield(handles, 'fit'))
        plot(handles.axes3, handles.ppm(:,handles.coordind)*(-1), handles.fit(:,handles.coordind), 'r');
    end
    xlabel(handles.axes3, 'ppm');
    hold(handles.axes3, 'off');   


% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    script_path = pwd;
    
    %get csvdata directory
    dir_path = uigetdir('dialog_title', 'Select a directory with csv files');
    
    if dir_path
        arrayfun(@cla,findall(0,'type','axes'));

        clearData_Callback(hObject, eventdata, handles);
        
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

        %if coord directory exist, read data cointains spectra and fit plots
        cd ('..');    
        main_path = pwd;
        if(exist(strcat(main_path,'/coord'), 'dir'))
            cd ('coord');
            coord_path = strcat(pwd, '/');
            handles.coordflag = 1;
            cd (script_path);
            coordfiles = dir(strcat(coord_path,'/*.coord'));
            if(length(coordfiles)>0)
                [ppm spectrum fit coord_files] = readcoord(coord_path);
                handles.ppm = ppm;
                handles.fit = fit;
                handles.spectrum = spectrum;
                handles.coordfiles = coord_files;
            end
        else
            handles.coordflag = 0;
            disp('No coord directory in this dataset');
        end
        
        %read tavle files
        cd (main_path);
        if(exist(strcat(main_path,'/table'), 'dir'))
            cd ('table');
            table_path = strcat(pwd, '/');
            handles.tableflag = 1;
            cd (script_path);
            tablefiles = dir(strcat(table_path,'/*.table'));
            if(length(tablefiles)>0)
                [snr fwhm table_files] = readtable(table_path);
                handles.snr = snr;
                handles.fwhm = fwhm;
                handles.tablefiles= table_files;
            end

        else
            handles.tableflag = 0;
            disp('No table directory in this dataset');
            set(handles.snrfield, 'String', 'N/A', 'Value',1)
            set(handles.fwhmfield, 'String', 'N/A', 'Value',1)
        end
        

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
            
            %find GPC+PCh index
            handles.refindex2 = strmatch('GPC+PCh', name, 'exact');
            handles.reference2 = met(:, handles.refindex2); 

        end  
    end
    %set handles
    guidata(hObject,handles);
    handles

% --- Executes on button press in stdev.
function stdev_Callback(hObject, eventdata, handles)
% hObject    handle to stdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stdev
    if(get(hObject,'Value')==1) set(handles.stderror, 'Value',0); end;
    calcMean_Callback(hObject, eventdata, handles);
    drawBar(handles)

% --- Executes on button press in stderror.
function stderror_Callback(hObject, eventdata, handles)
% hObject    handle to stderror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stderror
    if(get(hObject,'Value')==1) set(handles.stdev, 'Value',0); end;
    calcMean_Callback(hObject, eventdata, handles);
    drawBar(handles)


% --- Executes on selection change in mylistbox.
function mylistbox_Callback(hObject, eventdata, handles)
% hObject    handle to mylistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mylistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mylistbox

    % If double click mouse
    if strcmp(get(handles.figure1,'SelectionType'),'open')
        index_selected = get(handles.mylistbox,'Value');
        handles.index_selected = index_selected;
        file_list = get(handles.mylistbox,'String');
        % Item selected in list box
        filename = file_list{index_selected};
        % If folder
        %if  handles.is_dir(handles.sorted_index(index_selected))
            %cd (filename)
            % Load list box with new folder.
            %load_listbox(pwd,handles)

        [path,name,ext] = fileparts(filename);
        switch ext
            case '.csv'
                % Open FIG-file with guide command.
                disp(filename);                    
                drawBar(handles);
                % if coord directory loaded, find spectrum
                % corresponding to csv file
                if handles.coordflag
                    for i=1:numel(handles.coordfiles)
                        [coordpath, coordname, coordext] = fileparts(handles.coordfiles(i).name);
                        if strcmp(name,coordname)
                            disp(handles.coordfiles(i).name);
                            %set index of coord files which match to csv
                            %file
                            handles.coordind = i;
                            set(handles.errorText,'String', '', 'Value',1);
                            drawPlot(handles);                            
                            guidata(hObject,handles);
                            break;
                        else
                            set(handles.errorText,'String', 'No coord file matching to csv file', 'Value',1);
                            set(handles.errorText,'ForegroundColor','red');
                            cla(handles.axes3);

                        end
                    end    
                end
                if handles.tableflag
                    for i=1:numel(handles.tablefiles)
                       [tablepath, tablename, tableext] = fileparts(handles.tablefiles(i).name);
                        if strcmp(name,tablename)
                            disp(handles.tablefiles(i).name);
                            %set index of coord files which match to csv
                            %file
                            handles.tableind = i;
                            set(handles.errorText,'String', '', 'Value',1);
                            set(handles.snrfield, 'String', handles.snr(i), 'Value',1)
                            set(handles.fwhmfield, 'String', handles.fwhm(i), 'Value',1)
                            guidata(hObject,handles);
                            break;
                        else
                            set(handles.errorText,'String', 'No table file matching to csv file', 'Value',1);
                            set(handles.snrfield, 'String', 'N/A', 'Value',1)
                            set(handles.fwhmfield, 'String', 'N/A', 'Value',1)
                            set(handles.errorText,'ForegroundColor','red');
                            %cla(handles.axes3);

                        end
                   end    
                end
            otherwise
                try
                    % Use open for other file types.
                    %open(filename)
                catch ex
                    errordlg(...
                      ex.getReport('basic'),'File Type Error','modal')
                end

        end
        guidata(hObject,handles);
    end
    
    % if left click mouse
    if strcmp(get(handles.figure1,'SelectionType'),'normal')
        fileind_selected = get(handles.mylistbox,'Value');
        handles.fileind_selected = fileind_selected;
        handles.file_names(fileind_selected);
        guidata(hObject,handles);
        handles
    end


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


% --- Executes on button press in fullmetset.
function fullmetset_Callback(hObject, eventdata, handles)
% hObject    handle to fullmetset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fullmetset
    if(get(hObject,'Value')==1) set(handles.indmetset, 'Value',0); end;
    calcMean_Callback(hObject, eventdata, handles);     
    drawBar(handles)

% --- Executes on button press in indmetset.
function indmetset_Callback(hObject, eventdata, handles)
% hObject    handle to indmetset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of indmetset
    if(get(hObject,'Value')==1) set(handles.fullmetset, 'Value',0); end;
    calcMean_Callback(hObject, eventdata, handles);     
    drawBar(handles)



% --- Executes on button press in absoluteConcentration.
function absoluteConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to absoluteConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of absoluteConcentration
    if(get(hObject,'Value')==1) 
        set(handles.scaledConcentration, 'Value',0); 
        set(handles.scaledConcentrationGPC, 'Value',0); 
    end;
    calcMean_Callback(hObject, eventdata, handles);     
    drawBar(handles)
    

% --- Executes on button press in scaledConcentration.
function scaledConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to scaledConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scaledConcentration
    if(get(hObject,'Value')==1) 
        set(handles.absoluteConcentration, 'Value',0); 
        set(handles.scaledConcentrationGPC, 'Value',0); 
    end;
    calcMean_Callback(hObject, eventdata, handles);     
    drawBar(handles)

    

% --- Executes on button press in scaledConcentrationGPC.
function scaledConcentrationGPC_Callback(hObject, eventdata, handles)
% hObject    handle to scaledConcentrationGPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scaledConcentrationGPC
    if(get(hObject,'Value')==1) 
        set(handles.absoluteConcentration, 'Value',0); 
        set(handles.scaledConcentration, 'Value',0); 
    end;

    calcMean_Callback(hObject, eventdata, handles);     
    drawBar(handles)


function firstDivision_Callback(hObject, eventdata, handles)
% hObject    handle to firstDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstDivision as text
%        str2double(get(hObject,'String')) returns contents of firstDivision as a double
    handles.user_string1 = get(hObject,'String');
    if(isfield(handles, 'csvfiles'))
        x = {handles.csvfiles.name};
        y = handles.user_string1;
        
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
        handles.firstdivindex = index_temp;
        set(handles.firstdivfiles,'String', num2str(size(handles.firstdivindex,2)));
    end
    guidata(hObject,handles);
    calcMean_Callback(hObject, eventdata, handles);
    handles


% --- Executes during object creation, after setting all properties.
function firstDivision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function secondDivision_Callback(hObject, eventdata, handles)
% hObject    handle to secondDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondDivision as text
%        str2double(get(hObject,'String')) returns contents of secondDivision as a double
    handles.user_string2 = get(hObject,'String');
    if(isfield(handles, 'csvfiles'))
        x = {handles.csvfiles.name};
        y = handles.user_string2;
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
        handles.seconddivindex = index_temp;
        set(handles.seconddivfiles,'String', num2str(size(handles.seconddivindex,2)*size(handles.seconddivindex,1)));
    end
    guidata(hObject,handles);
    calcMean_Callback(hObject, eventdata, handles);
    handles

    

% --- Executes during object creation, after setting all properties.
function secondDivision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function snrLimit_Callback(hObject, eventdata, handles)
% hObject    handle to snrLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snrLimit as text
%        str2double(get(hObject,'String')) returns contents of snrLimit as a double
    handles.user_string3 = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function snrLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snrLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
            if(get(handles.scaledConcentrationGPC,'Value')==1)
                data_cell(2:end, 2:end) = num2cell(bsxfun(@rdivide, handles.group, handles.reference2));
                data_cell(1,1) = {'scaled concetration to GPC+PCh'};
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
% open figure in new window
function plot_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to plot_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Displays contents of axes1 at larger size in a new figure

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


% --------------------------------------------------------------------
function plot_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Create a figure to receive this axes' data
    axes2fig = figure;
    % Copy the axes and size it to the figure
    axes2copy = copyobj(handles.axes2,axes2fig);
    
    
    leghandle = findobj(handles.axes2,'type', 'legend')
    set(axes2copy,'Units','Normalized', 'Position',[.05,.20,.90,.60])
    get(leghandle);
    cla(handles.axes2);
    guidata(hObject,handles);

% --------------------------------------------------------------------
function plot_ax2_clear_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax2_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
     cla(handles.axes2);


function plot_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_ax3_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Create a figure to receive this axes' data
    axes3fig = figure;
    % Copy the axes and size it to the figure
    axes3copy = copyobj(handles.axes3,axes3fig);
    set(axes3copy,'Units','Normalized', 'Position',[.05,.20,.90,.60])
    cla(handles.axes3);
    guidata(hObject,handles);

% --------------------------------------------------------------------
function plot_ax3_clear_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax3_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     cla(handles.axes3);


% --------------------------------------------------------------------
function plot_axes3_Callback(hObject, eventdata, handles)
% hObject    handle to plot_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
            handles.reference2(handles.fileind_selected-2, :) = [];
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


% --- Executes on button press in addFile.
function addFile_Callback(hObject, eventdata, handles)
% hObject    handle to addFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(isfield(handles, 'group'))
        group_size = size(handles.group, 1);
        [filename pathname] = uigetfile('*.csv')
    else
        [filename pathname] = uigetfile('*.csv')
    end
    [name index num_files met met_files crb]=readcsv(strcat(pathname,'/',filename)); 
    handles.num_patient = handles.num_patient+1;
    handles.metabolites = name;
    handles.num_metabolite = numel(handles.metabolites);
    handles.group(end+1,:) = met;
    handles.crb(end+1,:) = crb;
    handles.csvfiles(end+1) = met_files;
    handles.file_names{end+1} = met_files.name;
    set(handles.mylistbox,'String',handles.file_names, 'Value',1);
    handles.sorted_index(end+1,:) = size(handles.sorted_index,1)+1;
    handles.sorted_index

    %find PC+Cr index
    handles.refindex = strmatch('Cr+PCr', name, 'exact');
    handles.reference(end+1,:) = met(:, handles.refindex); 
    
    handles.refindex2 = strmatch('GPC+PCh', name, 'exact');
    handles.reference2(end+1,:) = met(:, handles.refindex2); 
    guidata(hObject,handles);    
    handles



