function [time_max_L_raw, time_max_R_raw, delay_raw, time_max_L_cp, time_max_R_cp, delay_cp,time_max_L, time_max_R, delay] = IHTTOccipital(Params,left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right,time_vec,time_vec_cp,vertices)
% Calculates time of maximal activity of the current source density (CD) 
% and consequently, IHTT in 3 ways:
%   (I) on the original CD data
%   (II) on the CDs masked with the significant clusters obtained with cluster permutation (cp)
%   (III) on the time course of the number of vertices of the significant clusters obtained with cluster permutation 
%
%   INPUTS: 
%       Params              - structure containing the necessary paths and parameters for the analysis, initialized by GetParams().
%       left_1Dvec          - current source density averaged for trials and vertices within the left brain hemisphere [1 x #timepoints]
%       left_1Dvec_masked   - current source density averaged for trials and vertices within the left brain hemisphere after masking with the significant clusters obtained with cluster permutation [1 x #timepoints]
%       right_1Dvec         - current source density averaged for trials and vertices within the right brain hemisphere [1 x #timepoints]
%       right_1Dvec_masked  - current source density averaged for trials and vertices within the right brain hemisphere after masking with the significant clusters obtained with cluster permutation [1 x #timepoints]
%       maskingmatrix_left  - matrix used for masking the current source sensity for the left brain hemisphere [#vertices x #timepoints]
%       maskingmatrix_right - matrix used for masking the current source sensity for the right brain hemisphere [#vertices x #timepoints]
%       time_vec            - time vector associated with the timecourses of the current density [1 x #timepoints]
%       time_vec_cp         - time vector associated with the time of interest of the cluster permutation analysis [1 x #timepoints]
%       vertices            - structure containing the vertices of the brain mesh of the region of interest. vertices.Vertices: [1 x #vertices]
%
%   OUPUTS:
%       time_max_L_raw  - time of maximal activity on the left hemisphere measured on the original current source density (double)
%       time_max_R_raw  - time of maximal activity on the right hemisphere measured on the original current source density (double)
%       delay_raw       - IHTT measured on the original current source density (double)
%       time_max_L_cp   - time of maximal activity on the left hemisphere measured on the current source density masked with the significant clusters obtained with cluster permutation (double)
%       time_max_R_cp   - time of maximal activity on the right hemisphere measured on the current source density masked with the significant clusters obtained with cluster permutation (double)
%       delay_cp        - IHTT measured on the current source density masked with the significant clusters obtained with cluster permutation (double)
%       time_max_L      - time of maximal activity on the left hemisphere measured on the time course of the number of vertices of the significant clusters obtained with cluster permutation (double)
%       time_max_R      - time of maximal activity on the right hemisphere measured on the time course of the number of vertices of the significant clusters obtained with cluster permutation (double)
%       delay           - IHTT measured on the time course of the number of vertices of the significant clusters obtained with cluster permutation (double)
%
%   SYNTAX:
%       [time_max_L_raw, time_max_R_raw, delay_raw, time_max_L_cp, time_max_R_cp, delay_cp,time_max_L, time_max_R, delay] = IHTTOccipital(Params,left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right,time_vec,time_vec_cp,vertices)
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

% Define time range to look at
start_search = Params.IHTT.minsearch ; % start latency fot the search for peaks (ms)
end_search = Params.IHTT.maxsearch ;   % end latency fot the search for peaks (ms)
vertices_L = vertices(1).Vertices;     % define vertices for the left hemisphere
vertices_R = vertices(2).Vertices;     % define vertices for the right hemisphere

%% (I) IHTT measured on the original CD data

% Get peak of maximal activity on the left and right hemispheres
[time_max_L_raw] = get_peaks_for_IHTT(time_vec,start_search,end_search,left_1Dvec);  
[time_max_R_raw] = get_peaks_for_IHTT(time_vec,start_search,end_search,right_1Dvec); 

% Calculate IHTT depending on the side of the visual stimulation
if strcmp(Params.condname,'Left')
    delay_raw = time_max_L_raw - time_max_R_raw; 
elseif strcmp(Params.condname,'Right')
    delay_raw = time_max_R_raw - time_max_L_raw;
end

%% (II) IHTT measured on the time course of the number of vertices of the significant clusters obtained with cluster permutation 

% Get peak of maximal activity on the left and right hemispheres
[time_max_L_cp] = get_peaks_for_IHTT(time_vec_cp,start_search,end_search,left_1Dvec_masked);
[time_max_R_cp] = get_peaks_for_IHTT(time_vec_cp,start_search,end_search,right_1Dvec_masked);

% Calculate IHTT depending on the side of the visual stimulation
if strcmp(Params.condname,'Left')
    delay_cp = time_max_L_cp - time_max_R_cp;
elseif strcmp(Params.condname,'Right')
    delay_cp = time_max_R_cp - time_max_L_cp;
end

%% (III) IHTT measured on the the CDs masked with the significant clusters obtained with cluster permutation 

% Get number of vertices active left hemisphere (%)
n_vertices = [];
for i=1:size(maskingmatrix_left,2)
    n_vertices = [n_vertices sum(maskingmatrix_left(:,i))];
end
n_vertices_L = n_vertices/length(vertices_L)*100;

% Get number of vertices active right hemisphere (%)
n_vertices = [];
for i=1:size(maskingmatrix_right,2)
    n_vertices = [n_vertices sum(maskingmatrix_right(:,i))];
end
n_vertices_R = n_vertices/length(vertices_R)*100;

% Get peak of maximal activity on the left and right hemispheres
[time_max_L] = get_peaks_for_IHTT(time_vec_cp,start_search,end_search,n_vertices_L);
[time_max_R] = get_peaks_for_IHTT(time_vec_cp,start_search,end_search,n_vertices_R);

% Calculate IHTT depending on the side of the visual stimulation
if strcmp(Params.condname,'Left')
    delay = time_max_L - time_max_R;
elseif strcmp(Params.condname,'Right')
    delay = time_max_R - time_max_L;
end


end %end function

