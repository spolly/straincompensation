function str = strjoin(cstr, delimiter)
% strjoin is intended to mimic the function of strjoin in newer versions of octave
if (nargin < 2)
  delimiter = '';
end
str = '';
l = length(cstr);
if (l > 0)
  str = cstr{1};
  for k=2:l
    str = [str, delimiter, cstr{k}];
  end
end
end
