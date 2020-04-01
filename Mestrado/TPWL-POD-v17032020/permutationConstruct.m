function [P, wc] = permutationConstruct(W, nG)
% Create a permutation matrix to isolate well grid-blocks.
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   P = permutationConstruct(W, nG)
%
%   [P, wc] = permutationConstruct(W, nG)
%
% DESCRIPTION:
%
%   This function creates a permutation matrix for the well locations
%   in order to perform a high fidelity simulation on the well blocks 
%   instead of a TPWL/POD on these blocks, i.e., the original features
%   of these cells are maintained.
%
% REQUIRED PARAMETERS:
%
%   W  - Well structure defining existing wells;
%
%   nG - Number of cells (grid-blocks).
%
% RETURNS:
%
%   P   - Permutation matrix;
%
%   wc  - Array which contains the cells where there are well completions.

wc = [];
for i = 1:length(W)
    wc = [wc; W(i).cells];
end

I = speye(nG,nG);

rowsBelow = true(size(I,1),1);
rowsBelow(wc') = false;

% Construct the permutation matrix that will be used to multiply the basis
% function, including 1's at the proper location in the basis function
P = [I(:,wc') I(:,rowsBelow)];



