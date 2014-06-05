function [met_name, ind, num_files, met, files, sd] = readcsv(datapath)
sd_limit =15;

%Read all CSV files in 'datapath'
if(isdir(datapath))
    files = dir(strcat(datapath,'/*.csv'));
else
    files = dir(datapath);
    [datapath,name,ext] = fileparts(datapath);
end

ind = 0;
num_files = length(files);
if (num_files>0)
	met_cell=cell(1,1);
	sd_cell=cell(1,1);
	for i=1:num_files
		tmp=csvread(strcat(datapath,'/',files(i).name),1,2);
		met_cell{i}=tmp(1:3:end);
        num_met = size(tmp(1:3:end),2);
		sd_cell{i}=tmp(2:3:end);
	end
	fid = fopen(strcat(datapath,'/',files(i).name), 'r');
	C=textscan(fid, '%s','Delimiter',',');
	header = vertcat(C{:});
	met_name = header(3:3:((num_met*3)+2));
	fclose(fid);
    
    met = (reshape(cell2mat(met_cell), num_met, num_files))';
    sd = (reshape(cell2mat(sd_cell), num_met, num_files))';

	%Find metabolites with SD<15 in 70% of measurements
	[r,c]=find(sd<sd_limit);
	i=1;
	for n=1:num_met
		if(sum(c==n)>=(num_files*0.7))
			ind(i)=n;
			i=i+1;
		end
    end
    if(ind==0)
        ind(1) = 21;
    end
        
else
	ind=[];
	num_files=0;
	met_name=[];
end

end

