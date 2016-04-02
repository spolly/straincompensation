function rtn = strainProps(Param)
% STRAINPROPS returns properties needed for strain calculation
%
% Copyright (C) 2014--2015 Stephen J. Polly and Alex J. Grede
% GPL v3, See LICENSE for details
% This function is part of straincomp (https://nanohub.org/resources/straincomp)

  rtn = struct;
  rtn.a = 0;
  rtn.C11 = 0;
  rtn.C12 = 0;
  if isfield(Param, 'a_lc')
    if (~isnan(Param.a_lc))
      rtn.a = Param.a_lc*1e10;
    endif
  endif
  if isfield(Param, 'C')
    if (~isnan(Param.C(1, 1)))
      rtn.C11 = Param.C(1, 1)*1e-9;
    endif
    if (~isnan(Param.C(1, 2)))
      rtn.C12 = Param.C(1, 2)*1e-9;
    endif
  endif

endfunction
