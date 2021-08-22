# Makefile for dungeon

# The dungeon program provides a ``more'' facility which tries to
# figure out how many rows the terminal has.  Several mechanisms are
# supported for determining this; the most common one has been left
# uncommented.  If you have trouble, especially when linking, you may
# have to select a different option.

TERMFLAG = -DMORE_24

# Verbose dbug messaging can be turned on by uncommentin the line
# below.
#DEBUG = -D__DEBUG__

# Uncomment the following line if you want to have access to the game
# debugging tool.  This is invoked by typing "gdt".  It is not much
# use except for debugging.
GDTFLAG = -DALLOW_GDT

# This is the hostname of your hercules 3505 listener listening
# in EBCDIC mode. On MVS/CE this is running on localhost port 3506
HERCTCP = 127.0.0.1
HERCPORT = 3506

# Path to ncat
NETCAT = ncat

# JCC Options
JCCFOLDER   := ./jcc
JCC         := $(JCCFOLDER)/jcc
JCCINCS     := $(JCCFOLDER)/include
JCCOBJS     := $(JCCFOLDER)/objs
INC_DIRS    := $(JCCINCS) ./

##################################################################

INC_FLAGS   := $(addprefix -I,$(INC_DIRS))
D_FLAGS     := -D__MVS__
CC_FLAGS    := $(INC_FLAGS) $(D_FLAGS) $(DEBUG) -o
CC := $(JCC) $(CC_FLAGS)
PRELINK     := $(JCCFOLDER)/prelink

# Source files
CSRC =	actors.c ballop.c clockr.c demons.c dgame.c dinit.c dmain.c\
	dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c dsub.c dverb1.c\
	dverb2.c gdt.c lightp.c local.c nobjs.c np.c np1.c np2.c np3.c\
	nrooms.c objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

# Object files
OBJS =	actors.obj ballop.obj clockr.obj demons.obj dgame.obj dinit.obj dmain.obj\
	dso1.obj dso2.obj dso3.obj dso4.obj dso5.obj dso6.obj dso7.obj dsub.obj dverb1.obj\
	dverb2.obj gdt.obj lightp.obj local.obj nobjs.obj np.obj np1.obj np2.obj np3.obj\
	nrooms.obj objcts.obj rooms.obj sobjs.obj supp.obj sverbs.obj verbs.obj villns.obj

zork: $(OBJS) dtextc.dat
	$(PRELINK) -s $(JCCOBJS) zork.load $(OBJS)

%.obj: %.c
	@echo "# compiling " $<
	$(CC) $<

install: zork.load dtextc.dat
	rdrprep install.jcl
	cat reader.jcl | $(NETCAT) --send-only -w1 $(HERCTCP) $(HERCPORT)

clean:
	rm -f $(OBJS) zork.load dsave.dat *~

dtextc.dat:
	cat dtextc.uu1 dtextc.uu2 dtextc.uu3 dtextc.uu4 | uudecode

dinit.obj: dinit.c funcs.h vars.h
	$(CC) $(GDTFLAG) dinit.c >> jcc.log 2>&1

dgame.obj: dgame.c funcs.h vars.h
	$(CC) $(GDTFLAG) dgame.c >> jcc.log 2>&1

gdt.obj: gdt.c funcs.h vars.h
	$(CC) $(GDTFLAG) gdt.c >> jcc.log 2>&1

local.obj: local.c funcs.h vars.h
	$(CC) $(GDTFLAG) local.c >> jcc.log 2>&1

supp.obj: supp.c funcs.h vars.h
	$(CC) $(TERMFLAG) supp.c >> jcc.log 2>&1

actors.obj: funcs.h vars.h
ballop.obj: funcs.h vars.h
clockr.obj: funcs.h vars.h
demons.obj: funcs.h vars.h
dmain.obj: funcs.h vars.h
dso1.obj: funcs.h vars.h
dso2.obj: funcs.h vars.h
dso3.obj: funcs.h vars.h
dso4.obj: funcs.h vars.h
dso5.obj: funcs.h vars.h
dso6.obj: funcs.h vars.h
dso7.obj: funcs.h vars.h
dsub.obj: funcs.h vars.h
dverb1.obj: funcs.h vars.h
dverb2.obj: funcs.h vars.h
lightp.obj: funcs.h vars.h
nobjs.obj: funcs.h vars.h
np.obj: funcs.h vars.h
np1.obj: funcs.h vars.h parse.h
np2.obj: funcs.h vars.h parse.h
np3.obj: funcs.h vars.h parse.h
nrooms.obj: funcs.h vars.h
objcts.obj: funcs.h vars.h
rooms.obj: funcs.h vars.h
sobjs.obj: funcs.h vars.h
sverbs.obj: funcs.h vars.h
verbs.obj: funcs.h vars.h
villns.obj: funcs.h vars.h
