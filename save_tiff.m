 
filename = 'G:\result\harvest_date31.tif'
% %filename = 'G:\2008-2019HHMC\test\HHMC_year.tif' 
 geotiffwrite(filename,Q,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
%   path = 'G:\result\harvest_date29.tif';
%   A = readgeoraster(path);
% file = 'D:\G12017.tif';
% % K = csvread(file);
% geotiffwrite(file,K,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);