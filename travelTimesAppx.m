function [tPs, tPps, tPss] = travelTimesAppx(Vp, Vs, H, rayP, Hi)
% function [tPs, tPps, tPss] = travelTimesAppx(Vp, Vs, H, rayP, Hi)
% Authors: Evan Zhang
%
% Calculate travel times for Ps conversion and its multiples
% using approximation from Shi et al., 2020 JGR
%
% Input:
% Vp, Vs, H as vectors (H = 0 for half space)
% rayP as a vector
% Hi is the index of interface of interest (counting from top)
%
% ------------------------
% H(1), Vp(1), Vs(1)
% ------------------------ <- [Hi = 1]
% H(2), Vp(2), Vs(2)
% ------------------------ <- [Hi = 2]
% H(3), Vp(3), Vs(3)
%
% Output:
% tPs, tPps, tPss as vectors (length = length(rayP))

tPs0 = cumsum(H .* (1./Vs - 1./Vp));
tPps0 = cumsum(H .* (1./Vs + 1./Vp));
tPss0 = cumsum(2 * H .* (1./Vs));

tPs1 = tPs0 + (1/2) * rayP.^2 * cumsum(H .* (Vs + Vp));
tPps1 = tPps0 - (1/2) * rayP.^2 * cumsum(H .* (Vs + Vp));
tPss1 = tPss0 - rayP.^2 * cumsum(H .* Vs);

tPs_all = tPs0 + tPs1;
tPps_all = tPps0 + tPps1;
tPss_all = tPss0 + tPss1;

tPs = tPs_all(:,Hi);
tPps = tPps_all(:,Hi);
tPss = tPss_all(:,Hi);