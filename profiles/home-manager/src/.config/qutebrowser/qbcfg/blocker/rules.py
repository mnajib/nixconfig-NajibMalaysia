# PURE functions only: no file access, no globals, no side effects.
#   fnmatch.fnmatch       : Python stdlib, glob-style matching
#   urllib.parse.urlsplit : Python stdlib, split a URL into parts

from fnmatch import fnmatch
from urllib.parse import urlsplit


def pure_host(url: str) -> str:
    """Host part of a URL, or empty string."""
    return urlsplit(url).hostname or ""


def pure_strip_query(url: str) -> str:
    """Remove ?query and #fragment so the same script counts once."""
    return url.split("?")[0].split("#")[0]


def pure_parse_rules(lines):
    """Active rules only: list of (page_glob, script_glob)."""
    out = []
    for line in lines:
        s = line.strip()
        if not s or s.startswith("#"):
            continue
        parts = s.split()
        if len(parts) == 2:
            out.append((parts[0], parts[1]))
    return out


def pure_is_blocked(rules, page_url: str, request_url: str) -> bool:
    """True if any rule matches both the page and the requested file."""
    return any(fnmatch(page_url, p) and fnmatch(request_url, s)
               for p, s in rules)


def pure_resolve(target: str, prefix: str, last: list) -> str:
    """'d3' -> 3rd item of last report; anything else is used as typed.
    Raises ValueError for a number that is not in the report."""
    if target[:1].lower() == prefix and target[1:].isdigit():
        i = int(target[1:]) - 1
        if 0 <= i < len(last):
            return last[i]
        raise ValueError(f"No item {target} in the last report")
    return target


def pure_toggle_line(line: str) -> str:
    """Comment a rule line, or uncomment it."""
    if line.startswith("# "):
        return line[2:]
    return "# " + line
