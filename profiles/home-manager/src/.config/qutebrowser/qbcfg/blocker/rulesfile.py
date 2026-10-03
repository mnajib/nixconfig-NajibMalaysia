# IO: everything that touches blocked-scripts.txt.
#   message : qutebrowser.api, show text in the status bar

from qutebrowser.api import message

from .rules import pure_parse_rules
from .state import STATE


def io_read_lines():
    """Read the rules file, creating it (and its folder) with a header on first run."""
    path = STATE["rules_file"]
    if not path.exists():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(
            "## <page-glob> <script-glob>   (one rule per line)\n"
            "## '#' at the start = rule disabled; use :blk-toggle N\n"
            "# *://news.example.com/* *://cdn.example.com/popup.js*\n")
    return path.read_text().splitlines()


def io_write_lines(lines) -> None:
    STATE["rules_file"].write_text("\n".join(lines) + "\n")


def io_reload_rules() -> None:
    STATE["rules"] = pure_parse_rules(io_read_lines())


def io_append_rule(page_glob: str, script_glob: str) -> None:
    lines = io_read_lines()
    new = f"{page_glob} {script_glob}"
    if new in [l.strip() for l in lines]:
        message.info("Rule already exists")
        return
    io_write_lines(lines + [new])
    io_reload_rules()
    message.info(f"Added: {new}   (reload the page)")
