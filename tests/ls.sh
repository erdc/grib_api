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

cd ${data_dir}
infile=regular_gaussian_model_level.grib1

${tools_dir}grib_ls -P count $infile > log
${tools_dir}grib_ls -p count,step $infile >> log
${tools_dir}grib_ls $infile >> log
${tools_dir}grib_ls -l 0,0,1 $infile >> log
${tools_dir}grib_get -l 0,0,1 $infile >> log
${tools_dir}grib_get -p count,step $infile >> log
${tools_dir}grib_get -P count $infile >> log

files=" reduced_gaussian_lsm.grib1
reduced_gaussian_model_level.grib1
reduced_gaussian_model_level.grib2
reduced_gaussian_pressure_level.grib1
reduced_gaussian_pressure_level.grib2
reduced_gaussian_pressure_level_constant.grib1
reduced_gaussian_pressure_level_constant.grib2
reduced_gaussian_sub_area.grib1
reduced_gaussian_sub_area.grib2
reduced_gaussian_surface.grib1
reduced_gaussian_surface.grib2
reduced_latlon_surface.grib1
reduced_latlon_surface.grib2
regular_gaussian_model_level.grib1
regular_gaussian_model_level.grib2
regular_gaussian_pressure_level.grib1
regular_gaussian_pressure_level.grib2
regular_gaussian_pressure_level_constant.grib1
regular_gaussian_pressure_level_constant.grib2
regular_gaussian_surface.grib1
regular_gaussian_surface.grib2
regular_latlon_surface.grib1
regular_latlon_surface.grib2
"

for file in $files
do 
	echo $file >> log
	${tools_dir}grib_ls -l 40,28 $file  | grep index | awk '{print $4;}' >> log
done

diff log ls.log 
rm -f log

cd $workdir
