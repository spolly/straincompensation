function s = printDivider(cols)
% Formats generates a string with +---+ where --- length is defined by cols
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
s = strcat('+',...
           strjoin(...
                    arrayfun(@(n) repmat('-', [1, n]), cols,...
                             'UniformOutput', 0, '+'), '+'), '+');
