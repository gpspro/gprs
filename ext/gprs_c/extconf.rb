
require 'mkmf'

extension_name = 'gprs_c'
dir_config(extension_name)

# Specify source files & paths
$srcs = ['gprs_c.c', 'src/gprs.c', 'src/report.c']
$INCFLAGS << " -I$(srcdir)/src"
$VPATH << "$(srcdir)/src"

create_makefile(extension_name)