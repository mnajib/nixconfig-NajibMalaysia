# Shared mutable state. Data only, no logic.
# Other modules import these dicts and MUTATE them (never rebind), so every
# module always sees the same object.
#   pathlib.Path : Python stdlib, file paths

from pathlib import Path

STATE = {
    "logging": False,                            # is request logging on?
    "rules": [],                                 # active rules: [(page_glob, script_glob)]
    "last_d": [],                                # domains from last report (d1, d2, ...)
    "last_s": [],                                # script URLs from last report (s1, s2, ...)
    "rules_file": None,                          # set by setup()
    "report_file": Path("/tmp/qb-blk-report.html"),
    "registered": False,                         # interceptor registered yet?
}

# SEEN[page_host][request_host][url_without_query] = {type, count, blocked}
SEEN = {}
