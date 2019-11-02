---
title: Service monitoring
menu:
    main:
        parent: use
weight: 2
description: Monitoring services running on the gateway.
---

# Service monitoring

ChirpStack Gateway OS uses [Monit](https://mmonit.com/monit/) for monitoring
the ChirpStack components. It will periodically check if the configured services
are still running and if not, re-try to start them. It also allows for
monitoring the usage of resources (e.g. memory, cpu) and restart services
after a configured threshold. Please refer to the
[Monit manual](https://mmonit.com/monit/documentation/monit.html) for more
information.

## Command examples

To list the status of all monitored services, you need to run:

{{<highlight bash>}}
sudo monit status
{{</highlight>}}

To stop, start or restart a service, you need to run:

{{<highlight bash>}}
# start
sudo monit start SERVICE

# stop
sudo monit stop SERVICE

# restart
sudo monit restart SERVICE
{{</highlight>}}

## Important to know

Monit uses the `/etc/init.d/SERVICE` scripts to start these services. This
means you can also (for example) stop a service using `/etc/init.d/SERVICE stop`,
however Monit will then detect this as a failed service and will automatically
restart it.
