# render_pdf.py
import sys
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.units import cm
from bs4 import BeautifulSoup

def draw_wrapped(canvas, text, x, y, max_width, leading=12):
    # naive wrap
    import textwrap
    lines = textwrap.wrap(text, width=int(max_width/6))  # approx chars per line
    for line in lines:
        canvas.drawString(x, y, line)
        y -= leading
    return y

def main():
    if len(sys.argv) < 3:
        print("Uso: python3 render_pdf.py input.html output.pdf")
        sys.exit(1)
    html_path, pdf_path = sys.argv[1], sys.argv[2]

    with open(html_path, "r", encoding="utf-8") as f:
        soup = BeautifulSoup(f.read(), "html.parser")

    title = soup.find("h1").get_text(strip=True) if soup.find("h1") else "Estado de cuenta"
    smalls = [s.get_text(" ", strip=True) for s in soup.find_all("small")]

    # Table extraction
    rows = []
    table = soup.find("table")
    if table:
        for tr in table.find_all("tr"):
            cols = [td.get_text(" ", strip=True) for td in tr.find_all(["td","th"])]
            rows.append(cols)

    c = Canvas(pdf_path, pagesize=A4)
    width, height = A4
    x_margin, y_margin = 2*cm, 2*cm
    y = height - y_margin

    c.setFont("Helvetica-Bold", 14)
    y = draw_wrapped(c, title, x_margin, y, width - 2*x_margin, leading=16) - 6

    c.setFont("Helvetica", 10)
    for s in smalls:
        y = draw_wrapped(c, s, x_margin, y, width - 2*x_margin) - 2

    y -= 8
    c.setFont("Helvetica", 10)

    # Draw table
    if rows:
        col_widths = [ (width - 2*x_margin) * w for w in [0.20, 0.25, 0.55] ] if len(rows[0])==3 else None
        # fallback
        if not col_widths:
            col_count = len(rows[0])
            col_widths = [ (width - 2*x_margin) / col_count ] * col_count

        # header
        c.setFont("Helvetica-Bold", 10)
        y -= 14
        x = x_margin
        for i, val in enumerate(rows[0]):
            c.drawString(x + 4, y, val)
            x += col_widths[i]
        c.line(x_margin, y-2, width-x_margin, y-2)
        c.setFont("Helvetica", 10)

        # body
        for row in rows[1:]:
            y -= 14
            if y < y_margin + 2*cm:
                c.showPage()
                y = height - y_margin
            x = x_margin
            for i, val in enumerate(row):
                c.drawString(x + 4, y, val)
                x += col_widths[i]

    c.showPage()
    c.save()
    print(f"PDF generado: {pdf_path}")

if __name__ == "__main__":
    main()
