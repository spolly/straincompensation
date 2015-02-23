function s = printCenter(str, cols)
% Formats string with padding to put in center of s with len(cols)
% accepts cell arrays
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
if iscell(str)
  s = cell(size(str));
  for k=1:length(str)
    s{k} = printCenter(str{k}, cols(k));
  end
else
  wl = floor((cols+length(str))/2);
  wr = cols-wl;
  s = sprintf('%*s%*s', wl, str, wr,'');
end
end
