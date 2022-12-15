function [left,right,stat_left,stat_right,time_vec,time_vec_cp,vertices] = LoadData(Params)
% Loads the data for the analysis.
%
%   INPUTS: 
%       Params      - structure containing the necessary paths and parameters for the analysis, initialized by GetParams().
%
%   OUPUTS:
%       left        - current source density (CD) for the vertices within the left brain hemisphere [#trials x #vertices x #timepoints]
%       right       - current source density (CD) for the vertices within the right brain hemisphere [#trials x #vertices x #timepoints]
%       stat_left   - result of the cluster permutation for the left brain hemisphere [fieldtrip stats structure]
%       stat_right  - result of the cluster permutation for the right brain hemisphere [fieldtrip stats structure]
%       time_vec    - time vector associated with the timecourses of the current density [1 x #timepoints]
%       time_vec_cp - time vector associated with the time of interest of the cluster permutation analysis [1 x #timepoints]
%       vertices    - structure containing the vertices of the brain mesh of the region of interest. vertices.Vertices: [1 x #vertices]
%
%   SYNTAX:
%       [left,right,stat_left,stat_right,time_vec,time_vec_cp,vertices] = LoadData(Params)
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


% Load time vec
load(fullfile(Params.path_data,Params.subname,'time_vec.mat'))

% Load vertices of the brain region of interest
load(fullfile(Params.path_data,Params.subname,'Occipital_vertices.mat'))
vertices = Occip;

% Load current source density from the left hemisphere
disp('Loading data from the left hemisphere. It might take a while.')
load(fullfile(Params.path_data,Params.subname,sprintf('CD_%sVisualField_LeftBrainOccipital',Params.condname)))

% Load current source density from the right hemisphere
disp('Loading data from the right hemisphere. It might take a while.')
load(fullfile(Params.path_data,Params.subname,sprintf('CD_%sVisualField_RightBrainOccipital',Params.condname)))

% Load stats results after cluster permutation from the left hemisphere
load(fullfile(Params.path_data,Params.subname,sprintf('Stats_Source_%sVF_Occipital_LeftBrainOccipital.mat',Params.condname)))
stat_left = stat;

% Load stats results after cluster permutation from the right hemisphere
load(fullfile(Params.path_data,Params.subname,sprintf('Stats_Source_%sVF_Occipital_RightBrainOccipital.mat',Params.condname)))
stat_right = stat;

% Load time vec from cluster permutation analysis
time_vec_cp=stat.time;

end % end function