# PURE: builds the HTML report text. Writing it to disk is done in commands.py.
#   html.escape : Python stdlib, make text safe inside HTML

from html import escape


def pure_render_report(page_host, seen_page, rule_lines, rules_path):
    """Return (html, domain_list, script_list). Numbering is d1.. / s1.."""
    domains = sorted(seen_page,
                     key=lambda d: -sum(e["count"] for e in seen_page[d].values()))
    scripts, rows, n = [], [], 0
    for di, dom in enumerate(domains, 1):
        for url, e in sorted(seen_page[dom].items()):
            scripts.append(url)
            n += 1
            mark = "BLOCKED" if e["blocked"] else "ok"
            cls = "bad" if e["blocked"] else "ok"
            rows.append(
                f"<tr><td>d{di}</td><td>{escape(dom)}</td><td>s{n}</td>"
                f"<td>{escape(e['type'])}</td><td>{e['count']}</td>"
                f"<td class='{cls}'>{mark}</td>"
                f"<td class='u'>{escape(url)}</td></tr>")
    rule_rows = []
    for i, line in enumerate(rule_lines, 1):
        if line.strip() and not line.startswith("##"):
            off = line.startswith("#")
            rule_rows.append(
                f"<tr><td>{i}</td><td class='{'off' if off else 'bad'}'>"
                f"{'OFF' if off else 'ON'}</td><td class='u'>{escape(line)}</td></tr>")
    html = f"""<!doctype html><meta charset=utf-8><title>blk report</title>
<style>
 body{{font-family:monospace;margin:1.5em;background:#1e1e1e;color:#ddd}}
 table{{border-collapse:collapse;margin-bottom:2em}}
 td,th{{border:1px solid #444;padding:3px 8px;text-align:left}}
 .bad{{color:#ff6b6b;font-weight:bold}} .ok{{color:#7bd88f}} .off{{color:#888}}
 .u{{word-break:break-all}}
</style>
<h2>Requests seen on: {escape(page_host)}</h2>
<p>Block with <b>:blk-domain d3</b> or <b>:blk-script s7</b>
 (add <b>--everywhere</b> for all sites)</p>
<table><tr><th>dom</th><th>domain</th><th>scr</th><th>type</th><th>n</th>
<th>status</th><th>URL (no query)</th></tr>{''.join(rows)}</table>
<h2>Rules file: {escape(rules_path)}</h2>
<p>Toggle with <b>:blk-toggle N</b></p>
<table><tr><th>line</th><th>state</th><th>rule</th></tr>{''.join(rule_rows)}</table>
"""
    return html, domains, scripts
