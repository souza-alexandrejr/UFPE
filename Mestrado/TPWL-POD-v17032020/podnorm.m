function [normValue, minValue, maxValue] = podnorm(value)
% Normalize an array of values
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   normValue = podnorm(value)
%
%   [normValue, minValue, maxValue] = podnorm(value)
%
% DESCRIPTION:
%
%   This function normalizes an array of values, also returning the 
%   maximum and minimum value.
%
% REQUIRED PARAMETERS:
%
%   value      - Array which contains a data to be normalized;
%
% RETURNS:
%
%   normValue  - Array which contains normalized values of a data;
%
%   minValue   - Minimum value at 'value' array;
%
%   maxValue   - Maximum value at 'value' array.

minValue = min(min(value));
maxValue = max(max(value));

normValue = (value - minValue)/(maxValue - minValue);

end
