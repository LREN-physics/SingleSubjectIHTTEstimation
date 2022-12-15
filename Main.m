function Main()
% Main function for subjetc-specific interhemispheric transfer time (IHTT)
% estimation from EEG current density matrices following a Left and Right  
% Visual field stimulations. It calculates IHTT in 3 ways:
%   (I) on the original CD data
%   (II) on the CDs masked with the significant clusters obtained with cluster permutation (cp)
%   (III) on the time course of the number of vertices of the significant clusters obtained with cluster permutation 
%
%   INPUTS: 
%       none
%
%   OUPUTS:
%       none
%
%   FILES USED: 
%       Params.path_data/SubName/Stats_Source_CondNameVF_Occipital_LeftBrainOccipital.mat - Result of the cluster permutation for the left brain cortex for the CondNameVF, CondName being Left or Right visual stimulation (Fieldtrip stat structure)
%       Params.path_data/SubName/Stats_Source_CondNameVF_Occipital_RightBrainOccipital.mat - Result of the cluster permutation for the right brain cortex for the CondNameVF, CondName being Left or Right visual stimulation (Fieldtrip stat structure)
%       Params.path_data/SubName/CD_CondNameVisualField_LeftBrainOccipital.mat - Current source densities (pA.m) of each brain vertice, trial and time point for the left brain occipital cortex [#trials x #vertices x #timepoints]
%       Params.path_data/SubName/CD_CondNameVisualField_RightBrainOccipital.mat - Current source densities (pA.m) of each brain vertice, trial and time point for the right brain occipital cortex [#trials x #vertices x #timepoints]
%       Params.path_data/SubName/time_vec.mat - Time vector associated with the timecourses [1 x #timepoints]
%       Params.path_data/SubName/Occipital_vertices.mat - Structure containing the vertices of the brain mesh of the region of interest. Occipital_vertices.Vertices [1 x #vertices]
%
%   FILES GENERATED: 
%       Params.path_data/IHTT_CondNameVF_SS.mat (matrix containing the IHTT estimated for the CondNameVF condition)
%           Delay.raw (I), Delay.cp (II), Delay.nvoxels (III) are matrices [number of subjects x 3]  
%           The 3 columns are the time of maximal activity in the left hemisphere;
%           time of maximal activity in the right hemisphere; and the IHTT,
%           respectively.
%
%   EXTERNAL PACKAGES USED:
%       Fieldtrip
%    
%   SYNTAX:
%       Main()
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

% Get Paramaters and Paths for the analysis
Params = GetParams();
           
% LOOP FOR CONDITIONS 
for cond=1:length(Params.cond_list)
    
    fprintf('*** Working on %s visual field condition *** \n',Params.cond_list{cond})
    
    % LOOP FOR SUBJECTS
    for sub=1:length(Params.sub_list)
        
        fprintf('*** Working on subject %s *** \n',Params.sub_list{sub})
        
        % Update Params structure with subject name and condition name
        Params.subname = Params.sub_list{sub};
        Params.condname = Params.cond_list{cond};

        % Load source reconstructed data from each hemisphere  
        [left,right,stat_left, stat_right,time_vec,time_vec_cp,vertices] = LoadData(Params);
        
        % Cluster Permutation Masking
        [left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right] = MaskCDData(Params,left,right,stat_left,stat_right,time_vec,vertices);
        
        % Compute IHTT
        [time_max_L_raw, time_max_R_raw, delay_raw,time_max_L_cp, time_max_R_cp, delay_cp,time_max_L, time_max_R, delay] = IHTTOccipital(Params,left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right,time_vec,time_vec_cp,vertices);
        
        % Save results for each subject
        Delay_matrix.raw(sub,:) = [time_max_L_raw, time_max_R_raw, delay_raw];
        Delay_matrix.cp(sub,:) = [time_max_L_cp, time_max_R_cp, delay_cp];
        Delay_matrix.nvoxels(sub,:) = [time_max_L, time_max_R, delay];   
        
    end % end subject's loop
    
    % Save IHTT structure
    if strcmp(Params.condname,'Left')
        save(fullfile(Params.path_data,'IHTT_LeftVF_SS.mat'),'Delay_matrix')
    elseif strcmp(Params.condname,'Right')
        save(fullfile(Params.path_data,'IHTT_RightVF_SS.mat'),'Delay_matrix')
    end
    
end % end condition's loop

end % end function