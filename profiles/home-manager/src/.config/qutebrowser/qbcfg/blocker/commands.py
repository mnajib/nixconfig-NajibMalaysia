# IO: the ":blk-*" commands you type in qutebrowser.
#   apitypes, cmdutils, message : qutebrowser.api (Tab type, ":command" registration, status bar)

from qutebrowser.api import apitypes, cmdutils, message

from . import report, rules, rulesfile
from .state import SEEN, STATE


def io_resolve(target: str, prefix: str, last: list) -> str:
    """pure_resolve, but turns its ValueError into a qutebrowser error message."""
    try:
        return rules.pure_resolve(target, prefix, last)
    except ValueError as e:
        raise cmdutils.CommandError(str(e))


@cmdutils.register(name="blk-log")
def blk_log(state: str = "toggle") -> None:
    """Turn request logging on/off/toggle. Reload the page after turning on."""
    STATE["logging"] = {"on": True, "off": False}.get(state, not STATE["logging"])
    message.info(f"blk logging: {'ON' if STATE['logging'] else 'OFF'}")


@cmdutils.register(name="blk-report")
@cmdutils.argument("tab", value=cmdutils.Value.cur_tab)
def blk_report(tab: apitypes.Tab) -> None:
    """Write an HTML report of requests seen on the current page."""
    page_host = tab.url().host()
    seen_page = SEEN.get(page_host)
    if not seen_page:
        raise cmdutils.CommandError(
            "Nothing logged for this host. Run :blk-log on, then reload.")
    snapshot = {d: dict(u) for d, u in list(seen_page.items())}  # copy: thread-safe
    html, doms, scrs = report.pure_render_report(
        page_host, snapshot, rulesfile.io_read_lines(), str(STATE["rules_file"]))
    STATE["report_file"].write_text(html)
    STATE["last_d"], STATE["last_s"] = doms, scrs
    message.info(f"Report: {len(doms)} domains, {len(scrs)} files")


@cmdutils.register(name="blk-domain")
@cmdutils.argument("tab", value=cmdutils.Value.cur_tab)
def blk_domain(tab: apitypes.Tab, target: str, everywhere: bool = False) -> None:
    """Block a whole domain. TARGET = number like d3, or a host name."""
    host = io_resolve(target, "d", STATE["last_d"])
    page_glob = "*" if everywhere else f"*://{tab.url().host()}/*"
    rulesfile.io_append_rule(page_glob, f"*://{host}/*")


@cmdutils.register(name="blk-script")
@cmdutils.argument("tab", value=cmdutils.Value.cur_tab)
def blk_script(tab: apitypes.Tab, target: str, everywhere: bool = False) -> None:
    """Block one script. TARGET = number like s7, or a URL glob."""
    resolved = io_resolve(target, "s", STATE["last_s"])
    script_glob = resolved if "*" in resolved else resolved + "*"
    page_glob = "*" if everywhere else f"*://{tab.url().host()}/*"
    rulesfile.io_append_rule(page_glob, script_glob)


@cmdutils.register(name="blk-toggle")
def blk_toggle(line: int) -> None:
    """Comment/uncomment rule at LINE number (see the report's rules table)."""
    lines = rulesfile.io_read_lines()
    if not 1 <= line <= len(lines) or lines[line - 1].startswith("##"):
        raise cmdutils.CommandError(f"Line {line} is not a rule")
    lines[line - 1] = rules.pure_toggle_line(lines[line - 1])
    rulesfile.io_write_lines(lines)
    rulesfile.io_reload_rules()
    message.info(f"Line {line}: {lines[line - 1]}")
