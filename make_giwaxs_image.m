function img = make_giwaxs_image(bin_path,Imin,Imax)

% Input:
% bin_path: file path of binary image saved by wxdiff_api
% Imin/Imax: minimum and maximum intensity bounds, same as the sliders in
% WxDiff

% Output:
% Saves an image (.tif) of the GIWAXS pattern for publication

% Lots of hard coded stuff in here, all of which may vary with the
% instrument setup
im_width = 3006;
im_height = 2541;
Qxb = [350,1850];   % Axis limits on Qx in pixels
Qzb = [1000,2370];   % Axis limits on Qz in pixels
p2q = 0.00157028473292;    % Conversion from pixels to units of Q

fid=fopen(bin_path);
A=fread(fid,[im_width,im_height],'uint16');
fclose(fid)

% Set cutoffs and transpose
A=uint16(A);
A(A<Imin)=Imin;
A(A>Imax)=Imax;
A=A';
A=double(A);
AC=A(Qzb(1):Qzb(2),Qxb(1):Qxb(2));

% Make the jet colormapped image
cmap = colormap('jet');
irange = max(AC(:))-min(AC(:));
xind = double((0:length(cmap)-1))'...
       *(double(irange)/(length(cmap)-1))...
       + double(min(AC(:)));
img = cat(3,...
            reshape(interp1(xind,cmap(:,1),AC(:)),size(AC,1),size(AC,2)),...
            reshape(interp1(xind,cmap(:,2),AC(:)),size(AC,1),size(AC,2)),...
            reshape(interp1(xind,cmap(:,3),AC(:)),size(AC,1),size(AC,2))...
          );
imwrite(img,[bin_path(1:end-3), 'tif']);

end

% Past imbounds and sizes:
%------------------------------------
% Nils data from Ian
% im_width = 2873;
% im_height = 2596;
% Qxb = [400,1750];   % Axis limits on Qx in pixels
% Qzb = [800,2020];   % Axis limits on Qz in pixels
% p2q = 0.001866370230260;    % Conversion from pixels to units of Q
%------------------------------------
% im_width = 3006;
% im_height = 2541;
% Qxb = [350,1850];   % Axis limits on Qx in pixels
% Qzb = [1000,2370];   % Axis limits on Qz in pixels
% p2q = 0.00157028473292;    % Conversion from pixels to units of Q

