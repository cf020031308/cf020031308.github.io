# Kanban and OKR

## Kanban

看板不是用来管理任务（分类）的，而是用来定位瓶颈，以此为依据调度资源、改进流程的。

重中之重在于 WIP （Work In Progress, 最大在制品数量）的设置。

当为每条泳道设置了 WIP 后，就很容易在实践中看到任务是在哪条泳道堆积，这条泳道就是整个流程的瓶颈。

定位瓶颈后，改进该泳道，使得其 WIP 提升，整个流程变得更快。

之后继续定位新的瓶颈、改进。

## OKR

整体跟里程碑的设置比较像，分为 O（Objective）和 KR（Key Results）两个层次。


**Objective** 是用 inspiring 的语气定性地给出的全团队在接下来一个季度里需要专注的核心目标，可以理解为愿景。

* Objective 并不涉及多少专业所以方便理解，可以由上到下层层分解，可以团队间相互理解交流。
* 制定时必须是本团队可独立完成的，不能依赖不可控资源，以免甩锅。


**Key Results** 是 Objective 分解而来的定性的任务，是衡量 Objective 是否达到的充要条件。

## Github 上的实现

可以用 Github Issues 作为 Key Results，Issues 页里的 Milestones 作为 Objective。

用 Github Projects 作为 Kanban，将 Issues 加进来，更小的拆分用 Kanban 中的 Notes。
