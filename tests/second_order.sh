#!/bin/sh
# Copyright 2005-2007 ECMWF
#
# Licensed under the GNU Lesser General Public License which
# incorporates the terms and conditions of version 3 of the GNU
# General Public License.
# See LICENSE and gpl-3.0.txt for details.

. ./include.sh

rm -f log | true
workdir=`pwd`
REDIRECT=/dev/null

cd ${data_dir}

encoding=1
simple_no_bitmap=simple.grib
simple_bitmap=simple_bitmap.grib

files_no_bitmap="gen_ext.grib \
gen_ext_boust.grib \
gen_ext_spd_2.grib \
gen_ext_spd_3.grib \
gen.grib row.grib "

files_bitmap="constant_width_bitmap.grib \
constant_width_boust_bitmap.grib \
gen_bitmap.grib \
gen_ext_bitmap.grib \
gen_ext_boust_bitmap.grib \
gen_ext_spd_2_bitmap.grib \
gen_ext_spd_2_boust_bitmap.grib \
gen_ext_spd_3_boust_bitmap.grib \
simple_bitmap.grib"

no_packing="gen.grib|row.grib|gen_bitmap.grib|constant_width_bitmap.grib|constant_width_boust_bitmap.grib"

test_data() {
	${tools_dir}grib_filter test.filter $simple > $simple.data

	for f in $files
	do 
		${tools_dir}grib_filter test.filter $f > $f.data
		diff $simple.data $f.data > /dev/null
		${tools_dir}grib_compare -cvalues $f $simple
		echo $f decoding test passed > $REDIRECT

		exclude=`echo $f | awk " /$no_packing/ {print \"found\";} "`
		if [[ -z $exclude && $encoding != 0 ]]
		then
			rm -f $f.copied
			${tools_dir}grib_copy -r $f $f.copied
			${tools_dir}grib_filter test.filter $f.copied > $f.copied.data
			diff $simple.data $f.copied.data > /dev/null
			${tools_dir}grib_compare -cvalues $f.copied $simple
			echo $f encoding test passed > $REDIRECT
			echo > $REDIRECT
		fi

	done
	rm -f *.data *.copied
}


cat > test.filter<<EOF
print "[values!1]!";
EOF

simple=$simple_no_bitmap
files=$files_no_bitmap
test_data

simple=$simple_bitmap
files=$files_bitmap
test_data


