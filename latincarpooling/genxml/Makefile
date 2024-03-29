# (c) Copyright IBM Corp. 2003  All rights reserved.                 */
#                                                                    */
# This sample program is owned by International Business Machines    */
# Corporation or one of its subsidiaries ("IBM") and is copyrighted  */
# and licensed, not sold.                                            */
#                                                                    */
# You may copy, modify, and distribute this sample program in any    */
# form without payment to IBM,  for any purpose including developing,*/
# using, marketing or distributing programs that include or are      */
# derivative works of the sample program.                            */
#                                                                    */
# The sample program is provided to you on an "AS IS" basis, without */
# warranty of any kind.  IBM HEREBY  EXPRESSLY DISCLAIMS ALL         */
# WARRANTIES EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO*/
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTIC-*/
# ULAR PURPOSE. Some jurisdictions do not allow for the exclusion or */
# limitation of implied warranties, so the above limitations or      */
# exclusions may not apply to you.  IBM shall not be liable for any  */
# damages you suffer as a result of using, modifying or distributing */
# the sample program or its derivatives.                             */
#                                                                    */
# Each copy of any portion of this sample program or any derivative  */
# work,  must include a the above copyright notice and disclaimer of */
# warranty.                                                          */
#                                                                    */
# ********************************************************************/
# This Makefile builds the genxml bladelet
TARGET=$(INFORMIXDIR)/incl/dbdk/makeinc.linux
# TARGET must be set to the location/filename
# of the platform-specific make include file.
include $(TARGET)

# =================================================================
# This is the project title.
PROJECT_TITLE = genxml

# The linked DataBlade module is placed here.
BINDIR = $(OS_NAME)-$(PLATFORM)
INSTALL_DIR=./bin

# Platform independent code goes here.
# The following code was generated by BladeSmith.

MI_INCL   = $(INFORMIXDIR)/incl
COPTS     = -O -DMITRACE_OFF=1
CFLAGS    = -DMI_SERVBUILD $(CC_PIC) -I$(MI_INCL)/public $(COPTS)
LINKFLAGS = $(SHLIBLFLAG) $(SYMFLAG)
LIBS      =

# This is a list of the C object files.
PROJECTC_OBJS = \
	$(BINDIR)/$(PROJECT_TITLE).$(OBJSUFF)

PROJECT_LIBS = $(BINDIR)/$(PROJECT_TITLE).$(BLDLIB_SUFF)

all : $(BINDIR)
	$(MAKE) $(MAKEFLAGS) server $(BUILD_TARGET)

# Construct each object file.

$(BINDIR)/$(PROJECT_TITLE).$(OBJSUFF) : genxml.c
	$(CC) $(CFLAGS) -o $@ -c $?

# Construct the shared library.
# Do *NOT* link with client side  libraries.  You  will  see  many
# undefined symbols during linking.  This  is  normal  since those
# symbols are resolved when the server loads  your  shared object.
#
# ATTENTION:
# The  ld  "Symbol referencing errors"  warning  is  normal. These
# unresolved symbols are resolved when the server loads the shared
# object.  This list should be examined, however, for symbol names
# that may have been inadvertently  misspelled.  Misspelled symbol
# names will not be resolved here or at  load  time.  If a version
# 9.20 Informix Server is installed, these  symbols  are  filtered
# by the filtersym.sh script.
#
$(PROJECT_LIBS) : $(PROJECTC_OBJS)
	$(SHLIBLOD) $(LINKFLAGS) -o $(PROJECT_LIBS)		\
	$(PROJECTC_OBJS) $(LIBS)   				\
	$(DATABLADE_LIBS) 2> link.errs
	if test -x $(INFORMIXDIR)/bin/filtersym.sh ;		\
	then $(INFORMIXDIR)/bin/filtersym.sh link.errs ;	\
	else cat link.errs ;                        		\
	fi

server :	$(PROJECT_LIBS)
	cp $(PROJECT_LIBS) $(INSTALL_DIR)/.

clean :
	$(RM) $(RMFLAGS) $(PROJECT_LIBS) $(PROJECTC_OBJS)


$(BINDIR) :
	-mkdir $(BINDIR)
