function cake = analyze_cake(cake)

% cake is a structure with fields:
% Chi: vector of Chi values from a cake segment of a GIWAXS file
% I: vector of intensities from the same

sin_chi = sind(cake.Chi);
cos2chi = cosd(cake.Chi).^2;
I = cake.I;
cake.Hermans = sum(I.*cos2chi.*sin_chi) / sum(I.*sin_chi);

end