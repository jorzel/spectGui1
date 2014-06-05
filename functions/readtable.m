function [SNR FWHM files] = readtable(datapath)

files = dir(strcat(datapath, '/*.table'));
num_files = length(files)

if num_files > 0 
    for i=1:num_files
        fullpath = strcat(datapath,'/', files(i).name);
        paras = textread(fullpath,'%s','delimiter',' ');
        filelength=size(paras)
        for n=1:filelength(1)
            %disp(paras(n,1))
            if strcmp(paras(n,1),'S/N')
                SNR(i)=str2num(paras{n+2,1});
            end
            if strcmp(paras(n,1),'FWHM')
                ppm=str2num(paras{n+2,1});
            end
            if strcmp(paras(n,1),'hzpppm=')
                disp('jestem')
                hzppm=str2num(paras{n+1,1});
                FWHM(i) = hzppm*ppm; 
            end
            
        end
    end
end

