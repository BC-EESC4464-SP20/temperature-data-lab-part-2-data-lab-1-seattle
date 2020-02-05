function [P_all, P_recent] = StationTempObs_LinearTrend(station_number, RecentYear)

% StationTempObs_function  Analyze historical temperature observations
%===================================================================
%
% USAGE:  [P_all, P_recent] = StationTempObs_function(station_number, RecentYear)
%
% DESCRIPTION:
%   Use this function to calculate the seasonal climatology, annual mean
%   temperature and temperature anomaly, and trend over the historical
%   observed period for data from all stations in the Global Historical
%   Climatology Network (GHCN)
%
% INPUT:
%    staton_number: Number of the station from which to analyze historical temperature data
%    RecentYear: Beginning year for calculating temperature change up to the present day (set as 1960 in original function)
%
% OUTPUT:
%    P_all: slope and intercept of tempAnnMeanAnomaly over the full observational period
%    P_recent: slope and intercept of tempAnnMeanAnomaly from RecentYear to the end of the observational record
%
% AUTHOR:   Hilary Palevsky, 26 January 2020
%
% REFERENCE:
%    Written for EESC 4464: Environmental Data Exploration and Analysis, Boston College
%    Based on the Historical Temperature Records lab created by Sarah
%       Purkey for the University of Washington Program on Climate Change
%==================================================================

%% Read in the file for your station as a data table
filename = [num2str(station_number) '.csv'];
stationdata = readtable(filename);                                       

%% Calculate the annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array
tempData = table2array(stationdata(:,4:15));

%Calculate the mean, standard deviation, minimum, and maximum temperature
%for every month.
tempMean = nanmean(tempData);
tempStd = nanstd(tempData);
tempMin = min(tempData);
tempMax = max(tempData);

%% Fill missing values with the monthly climatological value
% Find all values of NaN in tempData and replace them with the
% corresponding climatological mean value calculated above.

% We can do this by looping over each month in the year:
for i = 1:12
    %use the find and isnan functions to find the index location in the
    %array of data points with NaN values
    indnan = find(isnan(tempData(:,i)) == 1); 
    %now fill the corresponding values with the climatological mean
    tempData(indnan,i) = tempMean(i);
end

%% Calculate the annual mean temperature for each year
tempAnnMean = mean(tempData');

%% Calculate the temperature anomaly for each year, compared to the 1981-2000 mean
% The anomaly is the difference from the mean over some baseline period. In
% this case, we will pick the baseline period as 1981-2000 for consistency
% across each station (though note that this is a choice we are making, and
% that different temperature analyses often pick different baselines!)

% Note that you could make the numbers 1981 and 2000 variables that you
% pass in to your function at the top to make this easier to adjust.

%Calculate the annual mean temperature over the period from 1981-2000
  %Use the find function to find rows contain data where stationdata.Year is between 1981 and 2000
ind_baseline = find(stationdata.Year <= 2000 & stationdata.Year >= 1981);
  %Now calculate the mean over the full time period from 1981-2000
baseline_mean = mean(tempAnnMean(ind_baseline));

%Calculate the annual mean temperature anomaly as the annual mean
%temperature for each year minus the baseline mean temperature
tempAnnMeanAnomaly = tempAnnMean - baseline_mean;

%% Calculate linear trends for whole time period, and for the time from RecentYear to today
%Here we will use the function polyfit to calculate a linear fit to the data
P_all = polyfit(stationdata.Year, tempAnnMeanAnomaly', 1);
    %also calculate the slope and intercept of a best fit line just from
    %1960 to the end of the observational period
indrecent = find(stationdata.Year == RecentYear);
P_recent = polyfit(stationdata.Year(indrecent:end), tempAnnMeanAnomaly(indrecent:end)', 1);

end