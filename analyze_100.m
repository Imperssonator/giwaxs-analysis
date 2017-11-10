function linecut = analyze_100(linecut)

% linecut is a structure with fields:
% Q: vector of Q values from a linecut of a GIWAXS file
% I: vector of intensities from the same

Q = linecut.Q;
I = linecut.I;

% Hard coded: where to start and stop the lorentz fit

fit_bounds = [0.29 0.455];
fit_inds = [find(linecut.Q>fit_bounds(1),1,'first'),...
            find(linecut.Q<fit_bounds(2),1,'last')];
        
% Perform lorentz fit

[YPRIME PARAMS RESNORM RESIDUAL] = lorentzfit( Q(fit_inds(1):fit_inds(2)),...
                                               I(fit_inds(1):fit_inds(2))...
                                             );

% Extract metrics from the fit

linecut.fitq = Q(fit_inds(1):fit_inds(2));
linecut.fity = YPRIME;
linecut.d100 = 2*pi/PARAMS(2);

% Grain size = K * lambda / (Beta * cos(theta))
% x-ray energy = 12.4 keV = 1.9867E-15 J
% bragg angle (theta) = 0.12 deg
% Beta = full width half max

x_wavelen = 1.9864E-25/1.9867E-15 * 1E10;  % Planck's hc / J, so meters, then 1E10 A/m
K = 0.9;    % Whatever
theta = 0.12;   % degrees

fwhm_inds = [find(YPRIME>max(YPRIME)/2,1,'first'),...
             find(YPRIME>max(YPRIME)/2,1,'last')];
         
linecut.fwhm = Q(fwhm_inds(2)) - Q(fwhm_inds(1));      % No need to correct for the shift from the truncation because it's just Q, not intensity
Beta = asin(linecut.fwhm * x_wavelen/(4*pi)) * 2;   % This is now in radians

linecut.GrainSize = K * x_wavelen / (Beta * cosd(theta));   % In Angstroms


end