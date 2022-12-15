function Params = GetParams()
% Creates the necessary parameters to run the analysis and defines the paths.
%
%   INPUTS: 
%       none
%
%   OUPUTS:
%       Params - structure containing the necessary paths and parameters
%       for the analysis.
%    
%   SYNTAX:
%       GetParams()
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

% Path where the data is located in your local folder
path_data = 'yourpath';
Params.path_data = path_data;

% Visual conditions used for stimulation
Params.cond_list = {'Left','Right'};

% List of subjects to analyze
Params.sub_list = {'sub_01','sub_02','sub_03','sub_04','sub_05','sub_06','sub_07','sub_08','sub_09','sub_10','sub_11','sub_12','sub_13','sub_14'};

% Parameters regarding the cluster permutation (CP) analysis that was
% previously conducted on the data
Params.CP.minsample = 206; % sample of the time vec where the cluster permutation started (100 ms)
Params.CP.maxsample = 359; % sample of the time vec where the cluster permutation ended (250 ms)

% Sample rate of the EEG data
Params.sr = 1024;   % Hz

% Parameters regarding the search for the maximal activity for IHTT estimation
Params.IHTT.minsearch = 130; % start latency for the search for peaks (ms)
Params.IHTT.maxsearch = 220; % end latency for the search for peaks (ms)

end % end function