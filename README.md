# CS 450 Machine Problem 3

## Objectives

In this machine problem, you'll be putting a new scheduler into xv6. It is
called a **lottery scheduler**, and the full version is described in [this
chapter](http://www.cs.wisc.edu/~remzi/OSFEP/cpu-sched-lottery.pdf) of
OSTEP; you'll be building a simpler one.  The basic idea is simple:
assign each running process a slice of the processor based in proportion to the
number of tickets it has; the more tickets a process has, the more it runs. Each
time slice, a randomized lottery determines the winner of the lottery; that
winning process is the one that runs for that time slice.

After completing this machine problem, you should be able to:

  - Explain the workings of a real OS CPU scheduler
  - Explain how a lottery scheduler works
  - Implement an OS scheduler


## Implementation details

You'll need two new system calls to implement this scheduler. The first is
`int settickets(int number)`, which sets the number of tickets of the calling
process. By default, each process should get one ticket; calling this routine
makes it such that a process can raise the number of tickets it receives, and
thus receive a higher proportion of CPU cycles. This routine should return 0
if successful, and -1 otherwise (if, for example, the caller passes in a
number less than one).

The second is `int getpinfo(struct pstat *)`. This routine returns some
information about all running processes, including how many times each has
been chosen to run and the process ID of each. You can use this system call to
build a variant of the command line program `ps`, which can then be called to
see what is going on. The structure `pstat` is defined below; note, you cannot
change this structure, and must use it exactly as is. This routine should
return 0 if successful, and -1 otherwise (if, for example, a bad or NULL
pointer is passed into the kernel).

Most of the code for the scheduler is quite localized and can be found in
`proc.c`; the associated header file, `proc.h` is also quite useful to
examine. To change the scheduler, not much needs to be done; study its control
flow and then try some small changes. 

You'll need to assign tickets to a process when it is created. Specfically,
you'll need to make sure a child process *inherits* the same number of tickets
as its parents. Thus, if the parent has 10 tickets, and calls `fork` to
create a child process, the child should also get 10 tickets.

You'll also need to figure out how to generate random numbers in the kernel;
some searching should lead you to a simple pseudo-random number generator,
which you can then include in the kernel and use as appropriate.

Finally, you'll need to understand how to fill in the structure `pstat` in the
kernel and pass the results to user space. The structure should look like what
you see here, in a file you'll have to include called `pstat.h`:

    #ifndef _PSTAT_H_
    #define _PSTAT_H_

    #include "param.h"

    struct pstat {
      int inuse[NPROC];   // whether this slot of the process table is in use (1 or 0)
      int tickets[NPROC]; // the number of tickets this process has
      int pid[NPROC];     // the PID of each process 
      int ticks[NPROC];   // the number of ticks each process has accumulated 
    };

    #endif // _PSTAT_H_


## Testing and Scoring

As with the previous machine problem, we include a test suite which you can run
with the command `make test-mp2`. The test source files (which you should not
alter --- we'll be using our own pristine copies in any case) can be found in
the "tests/mp2/ctests" directory if you're interested. 

If a test fails, it'll stop immediately with an error report. If you want to
continue running all tests even after hitting a failure, do `make test-mp2-cont`
instead.

---

There are a total of 7 tests. Tests 1, 2, 4, and 7 are worth 10 points each,
while test 3, 5, and 6 are worth 20 points each, for a maximum of 100 points. If
your code fails to build, you will not earn any points at all. If you do not
pass a test, you will not earn any points for it.


## Submission

To submit your work, simply commit all your changes and push your work to your
GitHub repository.

