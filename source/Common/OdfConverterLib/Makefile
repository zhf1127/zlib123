top_srcdir=../../..

include $(top_srcdir)/build/common.mk

ID_SUFFIX=CleverAge.OdfConverter.OdfConverterLib.resources

OOX2ODF_RES= \
    $(wildcard resources/oox2odf/*.xsl) \
    $(wildcard resources/oox2odf/*.xml) \
    $(wildcard resources/oox2odf/*.dtd)
OOX2ODF_XML= $(foreach file, $(OOX2ODF_RES), $(subst resources/oox2odf/,,$(file)))
PREFIX1=-resource:resources/oox2odf
ID_SUFFIX1=$(ID_SUFFIX).oox2odf
RESOURCE_FLAGS+=${foreach file, $(OOX2ODF_XML), $(PREFIX1)/$(file),$(ID_SUFFIX1).$(file)}

ODF2OOX_RES= \
    $(wildcard resources/odf2oox/*.xsl) \
    $(wildcard resources/odf2oox/*.xml) \
    $(wildcard resources/odf2oox/*.dtd)
ODF2OOX_XML= $(foreach file, $(ODF2OOX_RES), $(subst resources/odf2oox/,,$(file)))
PREFIX2=-resource:resources/odf2oox
ID_SUFFIX2=$(ID_SUFFIX).odf2oox
RESOURCE_FLAGS+=${foreach file, $(ODF2OOX_XML), $(PREFIX2)/$(file),$(ID_SUFFIX2).$(file)}

SOURCE=${wildcard *.cs}
DISTFILES=$(SOURCE) $(ODF2OOX_RES) $(OOX2ODF_RES)

all-local: OdfConverterLib.dll OdfConverterLibStatic.dll 
OdfConverterLib.dll: $(SOURCE) Makefile $(OOX2ODF_RES) $(ODF2OOX_RES)
	$(CSC) $(CSC_DEBUG) $(RESOURCE_FLAGS) -target:library -reference:../OdfZipUtils/OdfZipUtils.dll -r:System.Data \
		-out:$@ $(SOURCE)

OdfConverterLibStatic.dll: $(SOURCE) Makefile $(OOX2ODF_RES) $(ODF2OOX_RES)
	$(CSC) $(CSC_DEBUG) $(RESOURCE_FLAGS) -target:library -reference:../OdfZipUtils/OdfZipUtilsStatic.dll -r:System.Data \
		-out:$@ $(SOURCE)

clean-local:
	rm -f *.dll *.mdb *.pdb

dist-local: dist-common
