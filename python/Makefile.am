if WITH_PYTHON

pkgpyexec_LTLIBRARIES = _gribapi_swig.la

_gribapi_swig_la_SOURCES = gribapi_swig_wrap.c grib_interface.c grib_interface.h
_gribapi_swig_la_LIBADD = $(top_builddir)/src/libgrib_api.la $(PYTHON_LIBS)
_gribapi_swig_la_LDFLAGS = -module -avoid-version $(PYTHON_LDFLAGS)

INCLUDES = $(PYTHON_INCLUDES) -I$(NUMPY_INCLUDE)

gribapi_swig_wrap.c: swig_wrap_$(PYTHON_DATA_HANDLER).c
	cp swig_wrap_$(PYTHON_DATA_HANDLER).c gribapi_swig_wrap.c

gribapi_swig.py: swig_wrap_$(PYTHON_DATA_HANDLER).py
	cp swig_wrap_$(PYTHON_DATA_HANDLER).py gribapi_swig.py

# Extra stuff to go into the distribution
EXTRA_DIST = grib_interface.h \
			grib_interface.c \
			gribapi_swig.i \
			gribapi.py \
			numpy.i \
			grib_errors.h \
			extrules.am \
			dummy.am \
			swig_wrap_array.c \
			swig_wrap_numpy.c \
			swig_wrap_array.py \
			swig_wrap_numpy.py

# What else I want installed
pkgpyexec_DATA = \
	gribapi.py \
	gribapi_swig.py

CLEANFILES = \
			gribapi_swig_wrap.c \
			gribapi_swig.py \
			_gribapi_swig.la

include $(DEVEL_RULES)

endif
