function [baseline_model, P,tempAnnMeanAnomaly, Year] = StationModelProjections(station_number)

% StationModelProjections Analyze modeled future temperature projections at individual stations
%===================================================================
%

% USAGE:  [baseline_model, P, tempAnnMeanAnomaly] = StationModelProjections(station_number) 
%

% DESCRIPTION:
%   This function calculate the projected future rate of temperature change at each of the stations.  
%
% INPUT:
%    staton_number: Number of the station from which to analyze historical temperature data
%    
%
% OUTPUT:
%    baseline_model: [mean annual temperature over baseline period
%       (2006-2025); standard deviation of temperature over baseline period]
%    P: slope and intercept for a linear fit to annual mean temperature
%   
%
% AUTHORS:Kasey Cannon
%
% REFERENCE:
%    Written for EESC 4464: Environmental Data Exploration and Analysis, Boston College
%    Data are from the a global climate model developed by the NOAA
%       Geophysical Fluid Dynamics Laboratory (GFDL) in Princeton, NJ - output
%       from the A2 scenario extracted by Sarah Purkey for the University of
%       Washington's Program on Climate Change
%==================================================================

%% Read and extract the data from your station from the csv file
%filename = 'model61860.csv';
filename =['model' [num2str(station_number)] '.csv'];

stationdata = readtable(filename); 

%Extract the year and annual mean temperature data
Year = table2array(stationdata(:,1));

tempData = table2array(stationdata(:,2));

tempMean = nanmean(tempData);

for i = 1:length(tempData)
    
    indnan = find(isnan(tempData(i,:)) == 1);
    
    tempData(indnan) = tempMean;
end

tempAnnMean = tempData;

%% Calculate the mean and standard deviation of the annual mean temperatures
%  over the baseline period over the first 20 years of the modeled 21st
%  century (2006-2025) - if you follow the template for output values I
%  provided above, you will want to combine these together into an array
%  with both values called baseline_model
 %<-- (this will take multiple lines of code - see the procedure you
 %followed in Part 1 for a reminder of how you can do this)
 
ind_baseline= find(Year <= 2025 & Year >= 2006);

baseline_mean= mean(tempAnnMean(ind_baseline));

baseline_std = std(tempAnnMean(ind_baseline));


baseline_model= NaN(1,2);

baseline_model(:,1)= baseline_mean;

baseline_model(:,2)= baseline_std;

%% Calculate the 5-year moving mean smoothed annual mean temperature anomaly over the modeled period
% Note that you could choose to provide these as an output if you want to
% have these values available to plot.

tempAnnMeanAnomaly = tempAnnMean - baseline_mean;

tempAnnMeanSmooth= movmean(tempAnnMeanAnomaly,5);
 

%% Calculate the linear trend in temperature this station over the modeled 21st century period
 P=polyfit(Year,tempAnnMeanAnomaly,1);

end