close all
clear all

datapath = '/home/jorzel/Pulpit/badania/Zielinska/coord/';

files = dir(strcat(datapath, '/*.coord'))
num_files = length(files)

if num_files > 0 
	trash_raw = [];
	%h = waitbar(0, strcat('Please wait...'));
    %set(h, 'WindowStyle','modal', 'CloseRequestFcn','');
	for i=1:num_files
        %waitbar(i/num_files, h);
        %pause(.5)
		fullpath = strcat(datapath, files(i).name);
		id = fopen(fullpath, 'r');
		C = textscan(id, '%s');
		
		C = [C{:}];
		indexC = strfind(C, 'NY');
		index = find(not(cellfun('isempty', indexC)))
		
		tmp = C(index(1)+1:index(2));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
        size(cell2mat(tmp2(ind)))
		ppm_raw{i} = cell2mat(tmp2(ind));


		tmp = C(index(2)+1:index(3));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		spectrum_raw{i} = cell2mat(tmp2(ind));

		tmp = C(index(3)+1:index(4));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		fit_raw{i} = cell2mat(tmp2(ind));

    end
    %delete(h);
    ppm=cell2mat(fit_raw);
    spectrum = cell2mat(spectrum_raw);
    fit = cell2mat(fit_raw);

end


