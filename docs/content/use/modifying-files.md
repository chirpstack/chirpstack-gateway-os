---
title: Modifying files
menu:
    main:
        parent: use
weight: 2
description: Modifying files on the filesystem.
---

# Modifying files

ChirpStack Gateway OS uses an [OverlayFS](https://en.wikipedia.org/wiki/OverlayFS)
on top of the read-only root filesystem. This means you can make modifications that
are persisted even after a [Software update]({{< relref "software-update.md" >}})
as these changes are written to a different data partition.

## Important

Although this gives the complete freedom to make modifications to the root
filesystem, it also means that once you make a modification a ChirpStack Gateway OS
update will never "overwrite" this changed file. In reality, a ChirpStack Gateway OS
update will still update the file on the root filesystem, the OverlayFS will
present you the file from the data partition.

To "rollback" changes, you can simply remove these from `/data/upperdir`.
Removing all the content from `/data/upperdir` would effectively be a "factory reset".
