function rmvar(ProjectPath,filename, varargin)

cd (ProjectPath)
error(nargchk(2,inf,nargin));
vars = rmfield(load(filename),varargin(:));
save(filename,'-struct','vars');
