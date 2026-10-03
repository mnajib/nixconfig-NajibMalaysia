# IO: runs for EVERY request the browser makes.

from .rules import pure_host, pure_is_blocked, pure_strip_query
from .state import SEEN, STATE


def io_record(info, page_host, req_host, url_key, blocked) -> None:
    rtype = getattr(info.resource_type, "name", "unknown")
    # A new top-level navigation starts a fresh log for that page.
    if rtype == "main_frame":
        SEEN[page_host] = {}
    entry = (SEEN.setdefault(page_host, {})
                 .setdefault(req_host, {})
                 .setdefault(url_key, {"type": rtype, "count": 0, "blocked": False}))
    entry["count"] += 1
    entry["blocked"] = blocked


def io_intercept(info) -> None:
    """Log the request (if logging is on), then block it (if a rule matches)."""
    req = info.request_url.toString()
    if not req.startswith(("http://", "https://")):
        return
    page = info.first_party_url.toString()
    blocked = pure_is_blocked(STATE["rules"], page, req)
    if STATE["logging"]:
        io_record(info, pure_host(page), pure_host(req),
                  pure_strip_query(req), blocked)
    if blocked:
        info.block()
