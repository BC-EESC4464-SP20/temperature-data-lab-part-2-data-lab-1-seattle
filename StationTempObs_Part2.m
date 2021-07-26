%% Add a comment at the top with the names of all members of your group
% Kasey Cannon
%% 1. Load in a list of all 18 stations and their corresponding latitudes and longitudes
load GlobalStationsLatLon.mat 
%% 2. Calculate the linear temperature trends over the historical observation period for all 18 station
% You will do this using a similar approach as in Part 1 of this lab, but
% now implementing the work you did last week within a function that you
% can use to loop over all stations in the dataset


%Set the beginning year for the more recent temperature trend
RecentYear = 1960; %you can see how your results change if you vary this value

%Initialize arrays to hold slope and intercept values calculated for all stations
p_all = NaN(length(sta),2); %example of how to do this for the full observational period
%<-- do the same thing just for values from RecentYear to today
p_recent = NaN(length(sta),2);
%Use a for loop to calculate the linear trend over both the full
%observational period and the time from RecentYear (i.e. 1960) to today
%using the function StationTempObs_LinearTrend
for i=1:1:18
    
    station_number(i)=sta(i);
[P_all,P_recent]= StationTempObs_LinearTrend(station_number(i),RecentYear);

p_all(:,i)=P_all;
p_recent(i,:)=P_recent;
end

p_1=p_all(:,1)
%% 3a. Plot a global map of station locations
%Example code, showing how to plot the locations of all 18 stations
figure(1); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
plotm(lat,lon,'m.','markersize',15)
title('Locations of stations with observational temperature data')

%% 3b. Make a global map of the rate of temperature change at each station
% Follow the model from 3a, now using the function scatterm rather than plotm
%to plot symbols for all 18 stations colored by the rate of temperature
%change from RecentYear to present (i.e. the slope of the linear trendline)
figure(2); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,150, p_recent(:,1),'filled')
h=colorbar('southoutside');
title('Rate of temperature change from 1960 to present(ºC per decade)')

%% Extension option: again using scatterm, plot the difference between the
%local rate of temperature change (plotted above) and the global mean rate
%of temperature change over the same period (from your analysis of the
%global mean temperature data in Part 1 of this lab).
%Data visualization recommendation - use the colormap "balance" from the
%function cmocean, which is a good diverging colormap option



difference = (p_recent(:,1)- P_glob(1,1));

figure(3); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,150, difference,'filled') 
cmap = cmocean('balance','pivot',0);
colormap(cmap);
h=colorbar('southoutside');
title('Difference between local and global rate of temperature change from 1960 to present (ºC per decade)')


%% 4. Now calculate the projected future rate of temperature change at each of these 18 stations
% using annual mean temperature data from GFDL model output following the
% A2 scenario (here you will call the function StationModelProjections,
% which you will need to open and complete)

%Use the function StationModelProjections to loop over all 18 stations to
%extract the linear rate of temperature change over the 21st century at
%each station
% Initialize arrays to hold all the output from the for loop you will write
% below
P_grid = NaN(length(sta),2);
baseline_grid = NaN(length(sta),2);
tempAnnMeanAnomaly_grid = NaN(18,94);

% Write a for loop that will use the function StationModelProjections to
% extract from the model projections for each station:
% 1) the mean and standard deviation of the baseline period
% (2006-2025) temperatures, 2) the annual mean temperature anomaly, and 3)
% the slope and y-intercept of the linear trend over the 21st century
for i=1:18
    

[baseline_model,P,tempAnnMeanAnomaly,Year] = StationModelProjections(station_number(i));

P_grid(i,:)=P;
baseline_grid(i,:)=baseline_model;

tempAnnMeanAnomaly_grid(i,:)=tempAnnMeanAnomaly;
end
    
  
%% 5. Plot a global map of the rate of temperature change projected at each station over the 21st century
%<--
figure(4); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,120, P_grid(:,1).*10,'filled')
cmap = cmocean('balance');
V= [-1.5 1.5];
caxis(V)
colormap(cmap);
colorbar('southoutside');
axis off;
h=colorbar('southoutside');
title('Rate of projected temperature change from 2006 to 2099 (ºC per decade) ')



%% 6a. Plot a global map of the interannual variability in annual mean temperature at each station
%as determined by the baseline standard deviation of the temperatures from
%2005 to 2025
figure(5); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,120, baseline_grid(:,2),'filled')
h=colorbar('southoutside');

title('Baseline interannual variabilty (standard deviation) of annual mean temperature, 2006-2025')


%% 6b-c. Calculate the time of emergence of the long-term change in temperature from local variability
%There are many ways to make this calcuation, but here we will compare the
%linear trend over time (i.e. the rate of projected temperature change
%plotted above) with the interannual variability in the station's
%temperature, as determined by the baseline standard deviation

%Calculate the year of long-term temperature signal emergence in the model
%projections, calculated as the time (beginning from 2006) when the linear
%temperature trend will have reached 2x the standard deviation of the
%temperatures from the baseline period

year_grid = NaN(1,18);

for i= 1:1:18 
    
    year_test = 1:93;
  
    
    signal = P_grid(i,1).*year_test,
   
    noise = baseline_grid(i,2);
    
    I = find(signal>2*noise,1,'first');
    
    station_year=year_test(I);
    
    year_grid(i)=station_year;
    
      
end 

Emerg_year= year_grid+2006;
%Plot a global map showing the year of emergence

figure(6); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,120,Emerg_year,'filled')
h=colorbar;
title('Year of emergence of temperature increase')
