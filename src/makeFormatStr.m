function s = makeFormatStr(colTypes, cols, sep)
% Makes a string for use with spritnf
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)
strs = cell(size(colTypes));
for k=1:length(colTypes)
  pres = 4;
  if (iscell(colTypes{k}))
    ctype = colTypes{k}{1};
    if (length(colTypes{k}) > 1)
      pres = colTypes{k}{2};
    end
  else
    ctype = colTypes{k};
  end
  switch ctype
    case 's'
      strs{k} = sprintf('%%%is', cols(k));
    case 'sl' % Left justified string
      strs{k} = sprintf('%%-%is', cols(k));
    case 'blank'
      strs{k} = repmat(' ', [1, cols(k)]);
    case 'e'
      spl = floor((cols(k)-pres-6)/2);
      spr = cols(k)-spl-pres-6;
      strs{k} = sprintf('%*s%%0.%ie%*s', spl, '', pres, spr, '');
    case 'esgn'
      spl = floor((cols(k)-pres-7)/2);
      spr = cols(k)-spl-pres-7;
      strs{k} = sprintf('%*s%%+0.%ie%*s', spl, '', pres, spr, '');
    case 'i'
      spl = floor((cols(k)-pres-6)/2);
      spr = cols(k)-spl-pres-6;
      strs{k} = sprintf('%*s%%10i%*s', spl, '', spr, '');
    otherwise
      strs{k} = ctype;
  end
end
s = strjoin(strs, sep);
