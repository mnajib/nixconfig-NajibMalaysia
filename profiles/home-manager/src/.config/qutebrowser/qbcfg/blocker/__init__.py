# Entry point of the blocker package: config.py calls setup() once.
#
# Components used, and where they come from:
#   interceptor : qutebrowser.api (qutebrowser's own API), see/block every request
#   state, intercept, commands, rulesfile : sibling modules in this package

from qutebrowser.api import interceptor

from . import commands  # noqa: F401  (importing registers the :blk-* commands)
from . import intercept, rulesfile
from .state import STATE


def setup(config, rules_file) -> None:
    """Switch the blocker on. Safe to call again after :config-source."""
    STATE["rules_file"] = rules_file
    rulesfile.io_reload_rules()

    # Guard: :config-source re-runs config.py, but this module stays cached.
    # Without the guard the interceptor would be registered twice.
    if not STATE["registered"]:
        interceptor.register(intercept.io_intercept)
        STATE["registered"] = True

    config.bind(",bl", "blk-log toggle")
    config.bind(",br", f"blk-report ;; open -t {STATE['report_file'].as_uri()}")
