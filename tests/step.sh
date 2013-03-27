#!/bin/sh
# Copyright 2005-2007 ECMWF
#
# Licensed under the GNU Lesser General Public License which
# incorporates the terms and conditions of version 3 of the GNU
# General Public License.
# See LICENSE and gpl-3.0.txt for details.

. ./include.sh

REDIRECT=/dev/null

rm -f ${data_dir}/log | true
for i in 0 10
do
  for s in 0 1200 600 6000
  do
    for key in stepRange:s startStep endStep
	do
      rm -f ${data_dir}/out.grib | true
      ${tools_dir}grib_set -s ${key}=$s ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib
#      echo grib_set -s ${key}=$s ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib
#      grib_get -p step,startStep,endStep,P1,P2,timeRangeIndicator,indicatorOfUnitOfTimeRange ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib 
      ${tools_dir}grib_get -p mars.step,stepRange,startStep,endStep,P1,P2,timeRangeIndicator,indicatorOfUnitOfTimeRange:l ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib >> ${data_dir}/log
	done
  done
done

i=5
key=stepRange:s
for s in "0-24" "600-1200" "24-48" "36-66"
do
   ${tools_dir}grib_set -s ${key}=$s ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib
#   echo grib_set -s ${key}=$s ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib
#   grib_ls -p step,startStep,endStep,P1,P2,timeRangeIndicator,indicatorOfUnitOfTimeRange ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib 
   ${tools_dir}grib_get -p mars.step,stepRange,startStep,endStep,P1,P2,timeRangeIndicator,indicatorOfUnitOfTimeRange:l ${data_dir}/timeRangeIndicator_${i}.grib ${data_dir}/out.grib >> ${data_dir}/log
done

rm -f ${data_dir}/out.grib | true

# test added for ifs stepType=max,min
${tools_dir}grib_set -s stepType=max,startStep=3,endStep=6 ${data_dir}/reduced_gaussian_model_level.grib1 ${data_dir}/out.grib
${tools_dir}grib_get -p mars.step,stepRange,startStep,endStep,P1,P2,timeRangeIndicator,indicatorOfUnitOfTimeRange:l ${data_dir}/reduced_gaussian_model_level.grib1 ${data_dir}/out.grib >> ${data_dir}/log

rm -f ${data_dir}/out.grib | true

diff ${data_dir}/log ${data_dir}/step.log

(${tools_dir}grib_filter ${data_dir}/step_grib1.filter ${data_dir}/timeRangeIndicator_0.grib > ${data_dir}/log) 2>$REDIRECT

diff ${data_dir}/log ${data_dir}/step_grib1.log

rm -f ${data_dir}/log | true

# GRIB-180
# Set PDT 4.8 where you can find the EndOfOverallTimeInterval keys
grib2File=${data_dir}/reduced_latlon_surface_constant.grib2
${tools_dir}grib_set -sproductDefinitionTemplateNumber=8 $grib2File ${grib2File}.p8tmp

# 78 hours is 3 days and 6 hours
${tools_dir}grib_set -s step=78 $grib2File.p8tmp ${grib2File}.tmp
set `${tools_dir}grib_get -p hourOfEndOfOverallTimeInterval,dayOfEndOfOverallTimeInterval ${grib2File}.tmp`
hourEnd=$1; dayEnd=$2
[ "$hourEnd" = "18" ]
[ "$dayEnd" = "8" ]

${tools_dir}grib_set -s step=12 $grib2File.p8tmp ${grib2File}.tmp
set `${tools_dir}grib_get -p hourOfEndOfOverallTimeInterval,dayOfEndOfOverallTimeInterval ${grib2File}.tmp`
hourEnd=$1; dayEnd=$2
[ "$hourEnd" = "0" ]
[ "$dayEnd" = "6" ]

rm -f $grib2File.p8tmp ${grib2File}.tmp | true

