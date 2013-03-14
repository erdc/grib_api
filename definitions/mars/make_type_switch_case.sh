echo "			switch (val) {"
cat type.table | awk '{print "\t\t\t\tcase "$1":\n\t\t\t\t\t/* "$3" "$4" "$5" "$6" "$7" "$8" "$9" ("$2") */\n\t\t\t\t\tbreak;"}'

echo "				default :"
echo "					grib_context_log(a->parent->h->context,GRIB_LOG_ERROR,"unknown type %d",(int)val);"
echo "					return GRIB_ENCODING_ERROR;"
echo "			}"
