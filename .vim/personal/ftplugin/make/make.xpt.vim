XPTemplate priority=personal+


XPTinclude
      \ _common/common
      \ _comment/singleSign


XPT beerware " beerware licence
########################################################################################
#  @file        :  `file()^                                                            #
#  @author      :  `$author^ | `$email^                 #
#  @description :                                                                      #
#  @Copyrigths  :  `strftime("%Y")^                                                                #
#                                                                                      #
#  "THE BEER-WARE LICENSE" (Revision 42):                                              #
#  <krzysztof.kanas@gmail.com> wrote this file. As long as you retain this notice you  #
#  can do whatever you want with this stuff. If we meet some day, and you think        #
#  this stuff is worth it, you can buy me a beer in return  `$author^.   #
#  `cursor^                                                                                    #
########################################################################################

XPT simple " tryvial makefile to do it's stuff
.PHONY: all clean
targets:=

CXX_srcs:=$(wildcard *.cpp)
CXX_targets+=$(CXX_srcs:.cpp=)
CXX_objects:=$(CXX_srcs:.cpp=.o)

targets+=$(CXX_targets)

all: $(targets)

CXXFLAGS:=-Wall -Wextra -pedantic -ggdb
CXXLDFLAGS:=-Wall -Wextra -pedantic -ggdb

$(CXX_objects): %.o : %.cpp
	g++ -c $(CXXFLAGS) $< -o $@

$(CXX_targets): % : $(patsubst %,%.o,%)
	g++ $(CXXLDFLAGS)  -o $@ $<

clean:
	-rm $(targets) $(CXX_objects)

XPT cppBasicMake " basic makefile for cpp with dependency calculation stolen from automake
# this makefile bases on g++ ver > 3.0
.PHONY: all clean  depclean
NODEPS:=clean depclean

# name of output program
TARGET:=`cursor^

# suffix sources list
SUFFIX:=cpp
#sources list
SOURCES:=$(wildcard *.$(SUFFIX))

OBJS:=$(SOURCES:%.$(SUFFIX)=%.o)
DEPS:=$(SOURCES:%.$(SUFFIX)=%.d)

CXX=g++
# aditional flags:
# -pg for profliling
#  -Weffc++ - warning based on effective C++ by Scot Meyers
CCFLAGS= -g  -Wall -Wextra  -pedantic -std=c++98
LDFLAGS= -g  -Wall -Wextra  -pedantic -std=c++98


all: $(TARGET)


$(TARGET):  $(OBJS)
    $(CXX) $(LDFLAGS)  -o $@  $\^

$(OBJS): %.o: %.$(SUFFIX)
    $(CXX) $(CCFLAGS) -MT $@ -MMD -MP -MF $(patsubst %.o,%.d, $(@))  -c $< -o $@


ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
-include $(DEPS)
endif

depclean:
    rm -Rf  $(DEPS)

clean:
    rm -Rf $(TARGET) $(OBJS)

XPT cppAdvanceMake " some new make
# For quiet builds
Q:=@
# --no-builtin-rules  --no-builtin-variables
#  to speedup make and recover from strange errors
MAKEFLAGS += -rR --no-print-directory

# use PHONY variable to filter PHONY targers later on
PHONY:=

# Set Default target when nothing is given on cmdline
all: _all

# BUILD_DIR variable where build will be
BUILD_DIR:= .build/

# name of target
TARGET:=`cursor^
SUFFIX:=cpp
CC:=g++

#sources needed to compile
SOURCES:=$(wildcard *.$(SUFFIX))

# global build vars
INCLUDES:=$(addprefix -I,$(CURDIR) )
CCFLAGS:=  $(INCLUDES) -Wall -Wextra -pedantic -std=c++98 -Weffc++
LDFLAGS:= -Wall -Wextra  -pedantic
# -pg  for profiling output
# -Weffc++ for Warning according to Scot Meyers effective C++
# -std=c++98 version of standart to use

# to cancle all implicit rules on Makefile
$(CURDIR)/Makefile Makefile: ;

# variable to sppedup the build for cleaning we don't need dependencies
NODEPS:=clean depclean  distclean
PHONY+=$(NODEPS)

OBJS:=$(addprefix $(BUILD_DIR),$(SOURCES:%.$(SUFFIX)=%.o))
DIRS:=$(sort $(dir $(OBJS)))
DEPS:=$(addprefix $(BUILD_DIR),$(SOURCES:%.$(SUFFIX)=%.d))
TARGET_BUILD:=$(addprefix $(BUILD_DIR),$(TARGET))

_all:  $(DIRS) $(TARGET)

$(TARGET):  $(TARGET_BUILD)
    $(Q)echo "Target is now build at $(CURDIR)/$@"
    $(Q)cp $(TARGET_BUILD) $(TARGET)

$(TARGET_BUILD): $(OBJS)
    $(Q)echo "Linking $(@F)"
    $(Q)$(CC) $(LDFLAGS)  -o $@ $\^


# hack we can evaluate the rule at call or later,
define compileRule
$(addprefix $(BUILD_DIR), $(patsubst %.$(SUFFIX),%.o,$(1))): $(1)
    $(Q)echo "Compiling $$<"
    $(Q)$(CC) $(CCFLAGS) -MT $$@ -MMD -MP -MF $$(patsubst %.o,%.d, $$(@))  -c $$< -o $$@
endef

define dirRule
$(1):
    $(Q)echo "Creating dir $(1)"
    -$(Q)mkdir -p $(1)
endef

$(foreach targetdir, $(DIRS), $(eval $(call dirRule, $(targetdir))))
$(foreach src, $(SOURCES), $(eval $(call compileRule,$(src))))


ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
-include $(DEPS)
endif

depclean:
    -rm -Rf  $(DEPS)

clean:
    -rm -Rf $(TARGET) $(OBJS)

distclean:
    rm -Rf $(TARGET) $(BUILD_DIR)


.PHONY: $(PHONY)

XPT help-variables " some notes on gnu makefile magic variables
# $@                         The file name of the target.
# $<                         The name of the first pre requisite
# $?                         The names of all the prerequisites that are newer than the target,
# $\^  $+                   The names of all the prerequisites, $\^ ommits dupplicate prerequisites $+ preserves the order
# $*                         The name of steam which implicit rule matches( e.g foo bar: %: $* ; $* is either foo or bar)
# $(@D) $(?D) $(\^D) $(+D)
# $(@F) $(?F) $(\^F) $(+F)  The directory part and the file-within-directory part of $@ $< $? $\^ $+
#
# $(val:pattern=replacement)               eg.  $(val:.cpp=.o)
#    Replace all occuences of patter to replacement in variable
#    Equvalent of $(patsubst %.cpp,%.o,$(val))

# $(eval) functions is called twice so $ needs to be escaped in $$
# $(sort) will make list of strings unique (and sorted by the way if you care :)

# shell redirectron hack, to explain why building
# OLD_SHELL := $(SHELL)
# SHELL = $(warning Building $@$(if $<, (from $<))$(if $?, ($? newer)))$(OLD_SHELL)

XPT debug " simple debug rule for more advanced use DDD
print-%:
    @echo $* = $($*)

XPT printvars  " rule to print all variables declared so far
.PHONY: printvars
printvars:
    @$(foreach V,$(sort $(.VARIABLES)),                   \
        $(if $(filter-out environment% default automatic, \
        $(origin $V)),$(warning $V=$($V) ($(value $V)))))
# declare last or in file printvars.make and then make -f Makefile -f printvars.make printvars

XPT mscMake " msc geneate template
# mscgen makefile template

MSCGEN=$(shell which mscgen)

TYPE:=png
TARGET:=`cursor^

all: $(TARGET).$(TYPE)

$(TARGET).$(TYPE):  $(TARGET).msc
    $(MSCGEN) -T $(TYPE)  -i    $< -o $@

clean:
    -rm $(TARGET).$(TYPE)

XPT latexMake " simple hack for makefile to latex
TARGET:=`cursor^.pdf

.PHONY: $(TARGET) all pdf

all: $(TARGET)

pdf: $(TARGET)

$(TARGET): $(addsuffix .tex,$(basename $(TARGET)))
    pdflatex $<
    makeindex $<
    pdflatex $<
    latex_count=5 ; \
    while egrep -s 'Rerun (LaTeX|to get cross-references right)' hello.log && [ $$latex_count -gt 0 ] ;\
        do \
          echo "Rerunning latex...." ;\
          pdflatex $<;\
          latex_count=\`expr $$latex_count - 1\` ;\
        done


clean:
    rm -f *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out $(TARGET)


XPT old_amakecpp " advanced makefile for ccp with dependency calculation, with output stored in other dir
# this makefile bases on g++ ver > 3.0
.PHONY: all clean  depclean
NODEPS:=clean depclean

# name of target
TARGET:=`cursor^

# output dir creation pwd/build
CURR_DIR:= $(shell pwd)
OUTPUT_DIR:= $(addprefix $(CURR_DIR),/build/)
SUFFIX=cpp

#all sources needed to compile
SOURCES:=$(wildcard *.$(SUFFIX))

OBJS:=$(addprefix $(OUTPUT_DIR),$(SOURCES:%.$(SUFFIX)=%.o))
DIRS:=$(dir $(OBJS))
DEPS:=$(addprefix $(OUTPUT_DIR),$(SOURCES:%.$(SUFFIX)=%.d))
TARGET_BUILD:=$(addprefix $(OUTPUT_DIR),$(TARGET))


CXX:=g++

INCLUDES:=$(addprefix -I,$(CURR_DIR))
# -pg  for profiling output
# -Weffc++ for Warning according to Scot Meyers effective C++
CCFLAGS:= -g   $(INCLUDES) -Wall -Wextra  -pedantic -std=c++98
LDFLAGS:= -g  -Wall -Wextra  -pedantic -std=c++98



all: $(DIRS) $(TARGET)

$(TARGET): $(DIRS) $(TARGET_BUILD)
    cp $(TARGET_BUILD) $(TARGET)

$(TARGET_BUILD): $(OBJS)
    $(CXX) $(LDFLAGS)  -o $@  $\^

define compileRule
$(1)%.o: %.$(SUFFIX)
    $(CXX) $(CCFLAGS) -MT $$@ -MMD -MP -MF $$(patsubst %.o,%.d, $$(@))  -c $$< -o $$@
endef


define dirRule
$(1):
    -mkdir -p $(1)
endef

$(foreach targetdir, $(sort $(DIRS)), $(eval $(call dirRule, $(targetdir))))
$(foreach targetdir, $(DIRS), $(eval $(call compileRule, $(targetdir))))


ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
-include $(DEPS)
endif

depclean:
    -rm -Rf  $(DEPS)

clean:
    -rm -Rf $(TARGET) $(OBJS)

distclean:
    rm -Rf $(TARGET) $(OUTPUT_DIR)

XPT graphDot " Tryvial generate dot graph
# dummy makefile
.PHONY: all clean
targets:=

dots:=$(wildcard *.dot)
dot_targets:=$(dots:%.dot=%.jpg)

targets+=$(dot_targets)

all: $(targets)

CXXFLAGS:=-Wall -ggdb
CXXLDFLAGS:=-Wall -ggdb

$(dot_targets): %.jpg : %.dot
	dot -T jpg $< -o $@

clean:
	-rm $(targets)


