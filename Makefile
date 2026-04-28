# CMSC216 Project 4 Makefile
AN = p4
CLASS = 216
GS_COURSE_ID = 1239298
GS_ASSIGN_ID = 8016269

# -Wno-comment: disable warnings for multi-line comments, present in some tests
# CFLAGS = -Wall -Wno-comment -Werror -g  -Wno-format-security 
CFLAGS = -Wall -Werror -g -fstack-protector-all -Wno-format-security -Wno-format-overflow
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

# Some tests rely on the sorting order of ls AND the absence of
# unicode characters in the output of certain commands; setting the
# language to C will force ASCII ordering and usually not output
# unicode quote characters
LANG   = C

PROGRAMS = \
	bake

TEST_PROGRAMS = \
	test_bake_funcs12 \
	test_bake_funcs34 \


export PARALLEL?=True		#enable parallel testing if not overridden

all : $(PROGRAMS) 

clean :
	rm -f $(PROGRAMS) $(TEST_PROGRAMS) *.o core vgcore.*

clean-tests :
	rm -rf test-results 

help :
	@echo 'Typical usage is:'
	@echo '  > make                          # build all programs'
	@echo '  > make clean                    # remove all compiled items'
	@echo '  > make zip                      # create a zip file for submission'
	@echo '  > make prob1                    # built targets associated with problem 1'
	@echo '  > make test                     # run all tests'
	@echo '  > make test-prob2               # run test for problem 2'
	@echo '  > make test-prob2 testnum=5     # run problem 2 test #5 only'
	@echo '  > make update                   # download and install any updates to project files'
	@echo '  > make submit                   # upload submission to Gradescope'

############################################################
# 'make zip' to create complete.zip for submission
ZIPNAME = $(AN)-complete.zip
zip : clean clean-tests
	rm -f $(ZIPNAME)
	cd .. && zip "$(CWD)/$(ZIPNAME)" -r "$(CWD)"
	@echo Zip created in $(ZIPNAME)
	@if (( $$(stat -c '%s' $(ZIPNAME)) > 10*(2**20) )); then echo "WARNING: $(ZIPNAME) seems REALLY big, check there are no abnormally large test files"; du -h $(ZIPNAME); fi
	@if (( $$(unzip -t $(ZIPNAME) | wc -l) > 256 )); then echo "WARNING: $(ZIPNAME) has 256 or more files in it which may cause submission problems"; fi

################################################################################
# `make update` to get project updates
update :
ifeq ($(findstring solution,$(CWD)),)
	curl -s https://www.cs.umd.edu/~profk/216/$(AN)-update.sh | /bin/bash 
else
	@echo "Cowardly refusal to update solution"
endif

################################################################################
# `make submit` to upload to gradescope
submit : zip work-check
	@chmod u+x gradescope-submit
	@echo '=== SUBMITTING TO GRADESCOPE ==='
	./gradescope-submit $(GS_COURSE_ID) $(GS_ASSIGN_ID) $(ZIPNAME)

############################################################
# bake targets
%.o : %.c
	$(CC) -c $<

bake : bake_funcs.o bake_main.o bake_util.o
	$(CC) -o $@ $^

test_bake_funcs12 : test_bake_funcs12.o bake_funcs.o bake_util.o
	$(CC) -o $@ $^

test_bake_funcs34 : test_bake_funcs34.o bake_funcs.o bake_util.o
	$(CC) -o $@ $^

test_bake_funcs34.c :
	@ echo "=== NOTICE ==="
	@ echo "test_bake_funcs34.c is not yet available"
	@ echo "Watch for an announcement to download it"
	@ echo "=== NOTICE ==="

test_bake_funcs5 : test_bake_funcs5.o bake_funcs.o bake_util.o
	$(CC) -o $@ $^

# test_bake_funcs5.c :
# 	@ echo "=== NOTICE ==="
# 	@ echo "test_bake_funcs5.c is not yet available"
# 	@ echo "Watch for an announcement to download it"
# 	@ echo "=== NOTICE ==="

############################################################
# Testing Targets
test : test-prob1 test-prob2 test-prob3 test-prob4

test-setup:
	@chmod u+x testy

test-prob1 : test_bake_funcs12 test-setup test_prob1.org
	./testy test_prob1.org $(testnum)

test-prob2 : test_bake_funcs12 test-setup test_prob2.org
	./testy test_prob2.org $(testnum)

test-prob3 : test_bake_funcs34 test-setup test_prob3.org
	./testy test_prob3.org $(testnum)

test-prob4 : test_bake_funcs34 test-setup test_prob4.org bake
	./testy test_prob4.org $(testnum)

test-prob5 : test_bake_funcs5 test-setup test_prob5.org bake
	./testy test_prob5.org $(testnum)

# does a cursory check to see if the WORK_DISCLOSURE.txt doc is
# present and seems to have been edited to remove the template
work-check :
	@if [[ "$$NO_WORK_DISCLOSURE" == "1" ]]; then exit 0; fi;                  \
	grep -q -E 'SUBMITTER NAME|person[12]|Boo Kauthor' WORK_DISCLOSURE.txt;    \
	RESULT="$$?";                                                              \
	if [[ "$$RESULT" == "0" || "$$RESULT" == "2" ]]; then                      \
            printf '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n'; \
            printf '@@                    WARNING:                       @@\n'; \
            printf '@@  WORK_DISCLOSURE.txt is incomplete or unsigned.   @@\n'; \
            printf '@@  Loss of Credit is imminent. Finish that document @@\n'; \
            printf '@@  to correct this and prevent loss of credit.      @@\n'; \
            printf '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n'; \
	    printf '\nBypass this check with: `make NO_WORK_DISCLOSURE=1 ...` \n\n'; \
	    exit 1; \
	fi

