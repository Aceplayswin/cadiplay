"""Build a real .xlsx workbook from a header + rows.

Admin report downloads are saved as .xlsx. Serving CSV under that extension
makes Excel refuse the file ("format or file extension is not valid"). This
writer emits Office Open XML with the standard library so the download opens
in Excel without adding a spreadsheet dependency.
"""

from __future__ import annotations

from decimal import Decimal
from io import BytesIO
from xml.sax.saxutils import escape
from zipfile import ZIP_DEFLATED, ZipFile

_CONTENT_TYPES = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>
"""

_ROOT_RELS = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
"""

_WORKBOOK_RELS = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>
"""

_SHEET_NAME_FORBIDDEN = set(r':\/?*[]')
XLSX_CONTENT_TYPE = (
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
)


def _sheet_name(name: str) -> str:
    cleaned = ''.join('_' if ch in _SHEET_NAME_FORBIDDEN else ch for ch in name)
    cleaned = cleaned.strip("' ")[:31]
    return cleaned or 'Sheet1'


def _col_letter(index: int) -> str:
    letters = []
    while index:
        index, rem = divmod(index - 1, 26)
        letters.append(chr(65 + rem))
    return ''.join(reversed(letters))


def _xml_text(value: str) -> str:
    cleaned = ''.join(
        ch for ch in value
        if ch in '\t\n\r' or ord(ch) >= 32
    )
    return escape(cleaned)


def _cell_xml(ref: str, value) -> str:
    if value is None:
        return f'<c r="{ref}"/>'
    if isinstance(value, bool):
        return f'<c r="{ref}" t="b"><v>{"1" if value else "0"}</v></c>'
    if isinstance(value, (int, float, Decimal)):
        return f'<c r="{ref}"><v>{value}</v></c>'
    text = _xml_text(str(value))
    space = ' xml:space="preserve"' if text[:1] in ' \t' or text[-1:] in ' \t' else ''
    return f'<c r="{ref}" t="inlineStr"><is><t{space}>{text}</t></is></c>'


def _workbook_xml(sheet_name: str) -> str:
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"'
        ' xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        f'<sheets><sheet name="{_xml_text(sheet_name)}" sheetId="1" r:id="rId1"/>'
        '</sheets></workbook>'
    )


def _sheet_xml(header, rows) -> str:
    parts = [
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
        '<sheetData>',
    ]
    for row_idx, row in enumerate((header, *rows), start=1):
        cells = []
        for col_idx, value in enumerate(row, start=1):
            cells.append(_cell_xml(f'{_col_letter(col_idx)}{row_idx}', value))
        parts.append(f'<row r="{row_idx}">{"".join(cells)}</row>')
    parts.append('</sheetData></worksheet>')
    return ''.join(parts)


def xlsx_bytes(header, rows, sheet_name: str = 'Sheet1') -> bytes:
    """Return an .xlsx file as bytes for a single-sheet table."""
    name = _sheet_name(sheet_name)
    buffer = BytesIO()
    with ZipFile(buffer, 'w', ZIP_DEFLATED) as archive:
        archive.writestr('[Content_Types].xml', _CONTENT_TYPES)
        archive.writestr('_rels/.rels', _ROOT_RELS)
        archive.writestr('xl/workbook.xml', _workbook_xml(name))
        archive.writestr('xl/_rels/workbook.xml.rels', _WORKBOOK_RELS)
        archive.writestr('xl/worksheets/sheet1.xml', _sheet_xml(header, rows))
    return buffer.getvalue()
