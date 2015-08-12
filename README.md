# ChatLogger

ChatLogger is an opinionated IRC logs Web frontend.

 - Someone has already been logging - use the existing log files. No need for an additional bot just to log.
 - Log files are already *very* structured. No need to stuff them into any database.
 - The frontend should be modern and responsive *and* also work when used with `lynx` or `wget`.
 - IRC is text. Leave highlighting to the browser.
 - Browsing by time ranges is essential. You can link to a specific discussion easily.

The above results in two unique features: plaintext log files are filtered on-demand, and any highlighting is done on the browser. No need for any log prep, databases or another bot to clog the tubes.

Things that probably should be in but are not (yet):

 - ~~Don't cache today (as the log file is still growing, obviously)~~
 - Make log format somewhat less hard-coded. It assumes default [ZNC](http://wiki.znc.in/ZNC) log format
 - Turn links into actual links (maybe)
 - Also filter by nicks (more likely)
 - Also filter just messages (e.g. no joins, quits etc.; maybe)
 - Colorize individual nicks (meh)

**Status**: Consider beta. It works but is not polished.

![ChatLogger in action](http://i.imgur.com/MCOfkkM.png)

You can checkout current instance [here](http://tools.cataclysmdda.com/irc-logs).

## Setup

```bash
$ git clone https://github.com/drbig/chatlogger.git
$ cd chatlogger
$ $EDITOR .env
$ bundle install
$ rake assets:all
$ foreman start
```

## Contributing

Follow the usual GitHub workflow:

 1. Fork the repository
 2. Make a new branch for your changes
 3. Work (and remember to commit with decent messages)
 4. Push your feature branch to your origin
 5. Make a Pull Request on GitHub

## Licensing

Standard two-clause BSD license, see LICENSE.txt for details.

Copyright (c) 2015 Piotr S. Staszewski
