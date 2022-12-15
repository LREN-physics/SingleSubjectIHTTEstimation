function [left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right] = MaskCDData(Params,left,right,stat_left,stat_right,time_vec,vertices)
% Mask current density data (CD, pA.m) with the result of the cluster
% permutation analysis previously conducted.
%
%   INPUTS: 
%       Params      - structure containing the necessary paths and parameters for the analysis, initialized by GetParams().
%       left        - current source density for the vertices within the left brain hemisphere [#trials x #vertices x #timepoints]
%       right       - current source density for the vertices within the right brain hemisphere [#trials x #vertices x #timepoints]
%       stat_left   - result of the cluster permutation for the left brain hemisphere [fieldtrip stats structure]
%       stat_right  - result of the cluster permutation for the right brain hemisphere [fieldtrip stats structure]
%       time_vec    - time vector associated with the timecourses of the current density [1 x #timepoints]
%       vertices 	- structure containing the vertices of the brain mesh of the region of interest. vertices.Vertices: [1 x #vertices]
%
%   OUPUTS:
%       left_1Dvec          - current source density averaged for trials and vertices within the left brain hemisphere [1 x #timepoints]
%       left_1Dvec_masked   - current source density averaged for trials and vertices within the left brain hemisphere after masking with the significant clusters obtained with cluster permutation [1 x #timepoints]
%       right_1Dvec         - current source density averaged for trials and vertices within the right brain hemisphere [1 x #timepoints]
%       right_1Dvec_masked  - current source density averaged for trials and vertices within the right brain hemisphere after masking with the significant clusters obtained with cluster permutation [1 x #timepoints]
%       maskingmatrix_left  - matrix used for masking the current source sensity for the left brain hemisphere [#vertices x #timepoints]
%       maskingmatrix_right - matrix used for masking the current source sensity for the right brain hemisphere [#vertices x #timepoints]
%
%   EXTERNAL PACKAGES USED:
%       Fieldtrip
%
%   SYNTAX:
%       [left_1Dvec,left_1Dvec_masked,right_1Dvec,right_1Dvec_masked,maskingmatrix_left,maskingmatrix_right] = MaskCDData(Params,left,right,stat_left,stat_right,time_vec,vertices)
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

% LOOP FOR HEMISPHERE (1=left, 2=right)
for hem=1:2
    
    if hem==1       % Left hemisphere
        data = left;        % define data
        stat = stat_left;   % define stat structure
        Vertices_Interest = vertices(1).Vertices; % define vertices        
    elseif hem==2   % Right hemisphere
        data = right;       % define data
        stat = stat_right;  % define stat structure
        Vertices_Interest = vertices(2).Vertices; % define vertices
    end
    
    % Define variables
    ncond   = 2;                % number of conditions (baseline vs post-stimulus period)
    ntrial  = size(data,1);     % number of trials
    nchan   = size(data,2);     % number of vertices
    ntf     = size(data,3);     % number of time points
    
    % Define "electrodes" structure for fieldtrip
    channames           = Vertices_Interest';  % name of vertices
    elec                = [];
    for i=1:length(channames)
        elec.label{i} = ['',num2str(channames(i))];
        elec.unit{i} = 'pAm';
    end
    elec.label = reshape(elec.label ,[length(channames) 1]); % vertices names
    elec.unit = elec.unit';     % vertices units
    
    % Make template structure
    template_data              = [];
    template_data.fsample      = Params.sr;         % sampling rate
    template_data.avg          = nan(nchan,ntf);    % [1 x #timepoints]
    template_data.time         = time_vec(Params.CP.minsample:Params.CP.maxsample); % [1 x #timepoints]
    template_data.label        = elec.label ;       % [1 x #vertices]
    template_data.dimord       = 'chan_time';       % order of the data
    template_data.cfg          = [];        
    clear elec  i channames
    
    % Make structure with trials
    clear alltrials data_avg chanlocs;
    alltrials       = cell(ntrial,ncond); % initiate
    alltrials(:,:)  = {template_data};    % define all cells with the created template
    for trial = 1:ntrial  % create the baseline trials (first column of alltrials)
        alltrials{trial,1}.avg = ones(1,length(Params.CP.minsample:Params.CP.maxsample)).*mean(squeeze(data(trial,:,1:99)),2);
    end
    for trial = 1:ntrial  % create the post-stimulus trials (second column of alltrials)
        alltrials{trial,2}.avg = squeeze(data(trial,:,Params.CP.minsample:Params.CP.maxsample));
    end
    
    % Make baseline and post-stimulus averages
    cfg = [];
    cfg.channel         = 'all';
    cfg.latency         = 'all';
    cfg.parameter       = 'avg';
    GA_baseline         = ft_timelockgrandaverage(cfg,alltrials{:,1}); % baseline
    GA_activation       = ft_timelockgrandaverage(cfg,alltrials{:,2}); % post-stimulus
    
    % Make the absolute of the baseline and post-stimulus period 
    GA_activation.avg   = abs(GA_activation.avg);
    GA_baseline.avg     = abs(GA_baseline.avg);
    
    % Make the difference of the absolute of the baseline and post-stimulus period 
    cfg             = [];
    cfg.operation   = 'subtract';
    cfg.parameter   = 'avg';
    GA_diff         = ft_math(cfg,GA_activation,GA_baseline);
    
    % Get significant clusters - positive
    pos_cluster_pvals = [stat.posclusters(:).prob];
    pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha);
    pos = ismember(stat.posclusterslabelmat, pos_signif_clust);
    
    % Get significant clusters - negative
    neg_cluster_pvals = [stat.negclusters(:).prob];
    neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
    neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
    
    % Consider all the clusters and mask the ones that were absolute positive
    alltog = pos + neg;
    mask_positive = sign(GA_diff.avg);
    mask_positive(mask_positive~=1)=0;
    maskingmatrix = alltog.*mask_positive;
        
    % Multiply the final mask for the current densitiy data
    complete = squeeze(abs(mean(data(:,:,Params.CP.minsample:Params.CP.maxsample))));
    masked = complete.*maskingmatrix;
    
    % Average data over vertices
    masked_am = mean(abs(masked));
    
    % Save the original and masked current source density in one dimenstion
    % [1 x #timepoints] and save the final masking matrix [#vertices x
    % #timepoints]
    if hem==1       % Left hemisphere
        left_1Dvec = squeeze(mean(abs(mean(data))));
        left_1Dvec_masked = masked_am;
        maskingmatrix_left = maskingmatrix;
    elseif hem ==2  % Right hemisphere
        right_1Dvec = squeeze(mean(abs(mean(data))));
        right_1Dvec_masked = masked_am;
        maskingmatrix_right = maskingmatrix;
    end
    
end % end hemisphere loop   

end % end function