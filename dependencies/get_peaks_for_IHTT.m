function [time_max] = get_peaks_for_IHTT(time_vec,start_t,end_t,data)
% Auxiliar function to get the peak of maximal activity of the current
% source density timecourse
%
%   INPUTS: 
%       time_vec  - time vector associated with the timecourses of the current density [1 x #timepoints]
%       start_t   - latency (ms) used to start the search fot the peaks(double)
%       end_t     - latency (ms) used to end the search fot the peaks(double)
%       data      - current source density timecourse [1 x #timepoints]
%
%   OUPUTS:
%       time_max  - latency (ms) of maximal activity on the inputted current source density timecourse (double)
%
%   SYNTAX:
%       [time_max] = get_peaks_for_IHTT(time_vec,start_t,end_t,data)
%
% -------------------------------------------------------------------------
% Author: Rita Oliveira
% Email: rita.oliveira.uni@gmail.com
% Laboratory for Research in Neuroimaging (LREN)
% Department of Clinical Neuroscience, Lausanne University Hospital and University of Lausanne
% Mont-Paisible 16, CH-1011 Lausanne, Switzerland
%
% Last updated: 15/12/2022
% -------------------------------------------------------------------------

% Get index of the time vector for the start and end of the time window
% used for the search
[~,beg_sample] = min(abs(time_vec-start_t));
[~,end_sample] = min(abs(time_vec-end_t));

% Get the peaks within that timewindow
[pks, idx]=findpeaks(data(beg_sample:end_sample),'minpeakwidth',4);

% If there are no peaks, define time of maximal activity as NaN
if isempty(idx) 
    time_max=NaN;
% If there are peaks get the latency of the corresponding peak
else
    [~, j]=max(pks);                % chose the peak with maximum amplitude
    idx_max = idx(j);               % get the index of the corresponding peak
    idx_max = idx_max+beg_sample-1; % get the corresponding index with the all time vector
    time_max = time_vec(idx_max);   % get the latency (ms) of that peak form the time vector       
end


end % end function