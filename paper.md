---
title: title
abstract: abstract
---

# Introduction

[src-objclass-dev]: https://github.com/noahdesu/zlog-popper/tree/master/experiments/objclass-dev/visualize.ipynb
![\[[source][src-objclass-dev]\] Growth of officially supported, custom
object interfaces in RADOS over 6 years. A *method* is a specific object
interface and a *class* is a logical grouping of methods.](experiments/objclass-dev/output.png)

# Consolidated Section

Up until this point we have introduced Ceph, CORFU, the general problems
associated with programmability, described ZLog as being an instantiation of
the CORFU interface on top of Ceph.

Template for the CORFU object class interface. Maybe a simple state machine.

Describe indexing and protocol enforcement.
Differences between built-in interfaces and custom cls interfaces.

\begin{figure}
\centering
\begin{tikzpicture}[->,>=stealth',shorten >=1pt,auto,node distance=2.2cm,semithick]
%\tikzstyle{every state}=[fill=red,draw=none,text=white]

  \node[initial left,state] (A)              {$EG$};
  \node[state]         (B) [below right of=A] {$CP$};
  \node[state]         (D) [right of=B]       {$IO$};
  \node[state]         (C) [above right of=A] {$GC$};
  \node[state]         (E) [right of=C]       {$US$};
  \node[state]         (F) [below right of=E] {$Fi$};

  \path (A) edge        node [left] {R,W,F} (B)
            edge        node {T}     (C)
        (B) edge        node {F}     (C)
            edge        node {R,W}   (D)
        (C) edge        node {F,T}   (E)
        (D) edge        node {W}     (E)
            edge        node {R}     (F)
        (E) edge        node {F,T,W} (F);
\end{tikzpicture}
\caption{State transition diagram for read ($R$), write ($W$), fill ($F$), and
trim ($T$) CORFU operaitons. The states epoch guard ($EG$), check position ($CP$),
and update state ($US$) access metadata. The I/O performs a log entry read or
write, and garbage collection ($GC$) marks entries for reclamation.}
\end{figure}

# ZLog Physical Design

## Storage Interface Selection

\begin{table}
\begin{tabular}{ | l | l | l | l | l |}
\hline
Storage & Mapping & ESize & IP & PE \\ \hline
KV      & 1:1     & F     & Ceph  & KV/BS \\ \hline
BS      & 1:1     & F     & Ceph  & KV/BS \\ \hline
KV      & N:1     & D     & KV/BS & KV/BS \\ \hline
BS/Wr   & N:1     & F     & Ceph(VFS)   & KV/BS \\ \hline
BS/Wr   & N:1     & D     & \multicolumn{2}{|c|}{N/A} \\ \hline
BS/Ap   & N:1     & F/D   & KV/BS & KV/BS \\
\hline
\end{tabular}
\caption{asdf}
\end{table}

Constructing a complete implementation for each configuration would take
a lot of time, and may be time wasted if some configurations can be shown
to never be a viable option.

To winnow down the design space we ran a set of benchmarks---one for each
configuration--- that stressed the raw write performance using the built-in,
optimized interfaces on an unmodified version of Ceph. We explicitly avoided
simulating the costs associated with indexing or protocol enforcement in order
to form a clean baseline. Log entries may vary in size depending on the
application, but per-entry metadata is constant.

[src-librados-sweep]: https://github.com/noahdesu/zlog-popper/tree/master/experiments/librados-sweep/visualize.ipynb
![\[[source][src-librados-sweep]\] Throughput (IOPS) of 1K writes to a single
OSD using the standard I/O interfaces in various configurations. The best performance is achieved using
the byte stream interface and a N:1 mapping strategy.](experiments/librados-sweep/output.soft.reset.png)

The first thing to notice is that the configurations using a 1:1 mapping
perform poorly relative to the other configurations. This is unfortunate
because a 1:1 mapping simplifies data management by avoiding the need to
multiplex entries onto a smaller set of objects. However, even if performance
was acceptable, notice that throughput dramatically drops in the tail when the
number of objects reaches a threshold forcing the object cache to spill to
disk. Note that in a large cluster this mode may take a long time reach,
but we avoid it due to the inherent risk.

The KV/N:1 is a convenient configuration because the key-value interface
can be used to easily address log entries and manage index data. However, the
performance of KV/N:1 can vary widely depending on the size of the data entry.
As we will see next, even though the KV/N:1 configuration simplifies data
management, small entry performance falls behind that of N:1 configurations
that store data in the stream interface.

The configurations based on bytestream storage exhibit the best performance.
The *write* variation depends on client-side mapping to object offset and
indirectly on the VFS index layer within the OSD, but this method is
incompatible with non-fixed size entries. Alternatively, the *append* variation
supports both fixed and dynamic size entries, but leaves the indexing and
protocl enforcment challenges unsolved.

In conclusion, both *write* and *append* variation of bytestream configurations
are the best choice, with an edge given to *append* if it can support dynamic
sized entries without sacrificing performance.

## Metadata Management

[src-basic-cls-overhead]: https://github.com/noahdesu/zlog-popper/tree/master/experiments/basic-cls-overhead/visualize.ipynb
![\[[source][src-basic-cls-overhead]\] No Description.](experiments/basic-cls-overhead/output.1024.soft.reset.png)

Many variations of design here. What is the easiest way to 
winnow down the design space.

This is an easy interface to simulate.
- Check Epoch (omap, stream header)

Both protocol enforcement and logical address translation
represent a larger design space involving index design. However
since in either case all state must be stored in the omap and
in the stream header, testing the overhead of epoch enforcement
provides a strict upper bound on performance.

- Protocol Enforcement
- Logical Translation (only append case)

## Memory Cache

We solve the slow down of the epoch by storing the value in memory. Here is the new performance.

We generalize this as a new interface and use this interface to implement the full
zlog stack and show the performance.

Overall corfu is relatively simple abtraction, yet requires significant
work in making performant. Further, the decision may change over time.

# Abstract Model

![](experiments/throughput-sweep/output.png)

# Sequencer Creation
