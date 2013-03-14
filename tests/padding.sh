#!/bin/sh
# Copyright 2005-2007 ECMWF
# 
# Licensed under the GNU Lesser General Public License which
# incorporates the terms and conditions of version 3 of the GNU
# General Public License.
# See LICENSE and gpl-3.0.txt for details.


. ./include.sh

REDIRECT=/dev/null

${tools_dir}grib_set -s setLocalDefinition=1 ${data_dir}/regular_latlon_surface.grib1 loc.grib1
cat  > $$_f <<EOF
	if (GRIBEXSection1Problem ) {
		print "localDefinitionNumber=[localDefinitionNumber] size(GRIBEX-section1)=[GRIBEXSection1Problem] section1Length=[section1Length]";
		write "problem.grib";
		assert(0);
	}
EOF

localDefinitions=`find ${def_dir}/grib1/ -name 'local.98.*def' -printf '%f\n' |\
                awk 'BEGIN {FS=".";} {print $3;}' |\
                grep -v def |\
                sed '/245/d' |\
                sed '/244/d' |\
                sed '/192/d' |\
                xargs`

for l1 in $localDefinitions
do
	${tools_dir}grib_set -s localDefinitionNumber=$l1 loc.grib1 locx.grib1
	${tools_dir}grib_filter $$_f locx.grib1
	for l2 in $localDefinitions
	do
		${tools_dir}grib_set -s localDefinitionNumber=$l2 locx.grib1 locy.grib1
		${tools_dir}grib_filter $$_f locy.grib1
	done
done

rm -f $$_f locx.grib1 locy.grib1
