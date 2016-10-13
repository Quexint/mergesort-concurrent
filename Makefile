CC = gcc
CFLAGS = -std=gnu99 -Wall -g -pthread
OBJS = list.o threadpool.o main.o

.PHONY: all clean test

GIT_HOOKS := .git/hooks/pre-commit

all: $(GIT_HOOKS) sort

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

deps := $(OBJS:%.o=.%.o.d)
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -MMD -MF .$@.d -c $<

sort: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) -rdynamic

cache-test: sort
	uniq dictionary/words.txt | sort -R > input.txt
	for i in `(seq 2 2 32)`; do \
		perf stat --field-separator=, --repeat 1 \
			-e cache-misses,cache-references,instructions,cycles \
			./sort $$i input.txt output.txt 2>&1 \
			| sed -e "s/^/{$$i}Threads,/" \
			| grep miss >> runtime.txt; \
	done

plot: cache-test
	gnuplot scripts/catchmiss.gp
	gnuplot scripts/runtime.gp

clean:
	rm -f $(OBJS) sort input.txt output.txt runtime.txt
	@rm -rf $(deps)

-include $(deps)
