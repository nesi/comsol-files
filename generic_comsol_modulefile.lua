-- This file is a symlink target from the module tree.
-- Works for any COMSOL version so longs as the module and install dir are named like previous versions.

local COMSOL = "/opt/nesi/share/COMSOL"
local LICENSES = pathJoin(COMSOL, "Licenses")
local version = myModuleVersion()
local version_code = '1' ..  version:gsub('%.', '')
local root = pathJoin(COMSOL, 'comsol' .. version_code, 'multiphysics')

require 'io'
require 'os'
require 'lfs'
function file_readable(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

load("GLib/2.64.0-GCCcore-9.2.0")

local license_file = nil
for fn in lfs.dir(LICENSES) do
   if fn:sub(-4) == ".lic" then
      local candidate_licence_file = pathJoin(LICENSES, fn)
      if file_readable(candidate_licence_file) then
         license_file = candidate_licence_file
         break
      end
   end
end

if license_file ~= nil then
-- setenv('COMSOLLM_LICENSE_FILE', license_file)
    setenv('LMCOMSOL_LICENSE_FILE', license_file)
    setenv('LM_LICENSE_FILE', license_file)
elseif mode() == "load" then
   LmodError("You do not appear to be a member of any group licensed to use COMSOL")

end

conflict("COMSOL")

-- if not isloaded("MATLAB/2018b") then
--    load("MATLAB/2018b")
-- end

prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(LICENSES, "glnxa64"))   -- for lmutil etc.

whatis([[Description: COMSOL is a multiphysics solver that provides a unified workflow for electrical, mechanical, fluid, and chemical applications. - Homepage: https://www.comsol.com/]])


