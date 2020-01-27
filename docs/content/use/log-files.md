---
title: Log files
menu:
  main:
    parent: use
weight: 2
description: Finding the log files of the ChirpStack components.
---

# Log files

The ChirpStack components are writing their log output to [Syslog](https://en.wikipedia.org/wiki/Syslog),
which writes to `/var/log/messages`.

## All logs

To view the logs, run:

{{<highlight bash>}}
sudo tail -f /var/log/messages
{{</highlight>}}

## By service

To filter the messages by a specific service (e.g. `chirpstack-concentratord`),
run:

{{<highlight bash>}}
sudo tail -f /var/log/messages |grep chirpstack-concentratord
{{</highlight>}}
