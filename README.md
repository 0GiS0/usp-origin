![logo](https://raw.githubusercontent.com/unifiedstreaming/origin/master/unifiedstreaming-logo-black.png)

What is Unified Origin?
-----------------------
Unified Origin offers one solution for just-in-time packaging to MPEG-DASH, Apple (HLS), Adobe (HDS) and Microsoft (MSS). Our added features include content protection, restart TV, time-shift, catchup-TV, subtitles, and multiple language and audio tracks.

Further documentation is available at: <http://docs.unified-streaming.com>

Usage
-----
This image is usable out of the box, but must be configured using environment variables.

Available variables are:

|Variable        |Usage   |Mandatory?|
|----------------|--------|----------|
|USP_LICENSE_KEY |Your license key. To evaluate the software you can create an account at <https://private.unified-streaming.com/register/>|Yes|
|LOG_LEVEL|Sets the Apache error log level|No|
|LOG_FORMAT|Sets a custom Apache log format|No|


Example
-------
A simple example, running locally on port 1080 with remote storage in S3 and debug logging:

```bash
docker run \
  -e USP_LICENSE_KEY=<license_key> \ 
  -e LOG_LEVEL=debug \
  -p 1080:80 \
  unifiedstreaming/origin:1.10.28
```

Tutorial
--------
A full tutorial is available at <http://docs.unified-streaming.com/installation/evaluation.html>
