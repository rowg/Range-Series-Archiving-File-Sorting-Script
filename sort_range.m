% sort_range.m
% I had the daily range folders created by the Archivalist software in yearly folders already.
% This script moves files that are in the following structure:
% oldbasepath/yyyy/(dailyfolders) where oldbasepath is my original base path and yyyy is the year
% and places them into the agreed upon structure for range archival creating directories as needed
% newbasepath/XXXX/RangeSeries/yyyy/mm/dd/(dailyrangefiles) OR
% newbasepath/XXXX/Spectra/yyyy/mm/dd/(dailycssfiles) if the ftype is 'spectra'
% Handles leap years from 1992 to 2096
% If you prefer to move the files instead of copying, change !cp to !mv in
% the code.
%
%INPUTS:
%site -- string containing the four letter site code, e.g. 'VIEW'
%years -- numeric, array of years for the range data
%ftype -- string, either 'range' or 'spectra',  defaults to 'range' if not specified
%sort_range('XXXX',[2000:2014],'range')

function [] = sort_range(site,years,ftype)

oldbasepath = ['/Users/tupdyke/',site,'/'];  % ENTER YOUR BASE PATH FOR THE ORIGINAL LOCATION OF FILES
newbasepath = '/Volumes/Axiom5Tb02/MARACOOS/';  % ENTER YOUR NEW BASE PATH

if ~exist('ftype','var')
    ftype = 'range';
end

if strcmp(ftype,'range')
    bp = [newbasepath,site,'/RangeSeries/'];
    oldbasepath = [oldbasepath,'RangeSeries/'];
elseif strcmp(ftype,'spectra')
    bp = [newbasepath,site,'/Spectra/'];
    oldbasepath = [oldbasepath,'Spectra/'];
end

fprintf('\nCopying from: %syyyy/(dailyArchivalistfolders)\n',oldbasepath)
fprintf('to: %syyyy/mm/dd/(dailydatafiles)\n\n',bp)
input('This script works with daily Archivalist folders that are already in yearly folders.\nPlease enter your paths in the code before running the script! \nNote: If you prefer to move the files instead of copying, change !cp to !mv in the code.\nPress enter to continue or control-C to quit.','s');

leapyears = [1992 1996 2000 2004 2008 2012 2016 2020 2024 2028 2032 2036 2040 2044 2048 2052 2056 2060 2064 2068 2072 2076 2080 2084 2088 2092 2096];

for yy = 1:length(years)
    ndays = [31 28 31 30 31 30 31 31 30 31 30 31];
    if ismember(years(yy),leapyears)
        ndays(2) = 29;
    end
    ystr = ['!mkdir ',bp,num2str(years(yy))];
    eval(ystr);
    
    for mm = 1:12
        mstr = ['!mkdir ',bp,num2str(years(yy)),'/',append_zero(mm)];
        eval(mstr);
        
        
        for dd = 1:ndays(mm)
            dstr = ['!mkdir ',bp,num2str(years(yy)),'/',append_zero(mm),'/',append_zero(dd)];
            eval(dstr);
            
            % insert move statement here
            if strcmp(ftype,'range')
                cstr = ['!cp ',oldbasepath,num2str(years(yy)),'/',site,'_RNG_',num2str(years(yy)),'_',append_zero(mm),'_',append_zero(dd),'/* ',bp,num2str(years(yy)),'/',append_zero(mm),'/',append_zero(dd),'/.' ];
            elseif strcmp(ftype,'spectra')
                y2 = num2str(years(yy));
                y2 = y2(3:4);
                cstr = ['!cp ',oldbasepath,num2str(years(yy)),'/',site,'_CSS_*/*',y2,'_',append_zero(mm),'_',append_zero(dd) '_* ',bp,num2str(years(yy)),'/',append_zero(mm),'/',append_zero(dd),'/.' ];
            end
            fprintf('%s\n',cstr);  % for troubleshooting
            eval(cstr);
            
        end
        
    end
end


function N=append_zero(n)
% returns 0n if n<10; retuns n if n>=10

if n>9
    N=num2str(n);
else
    N=['0' num2str(n)];
end
