command -range FormatJson :call FormatJson()

function! FormatJson() range
  let [l1, col1] = getpos("'<")[1:2]
  let [l2, col2] = getpos("'>")[1:2]
python << EOF
import vim
import json
start = int(vim.eval('l1')) - 1
end = int(vim.eval('l2')) - 1
col1 = int(vim.eval('col1')) - 1
col2 = int(vim.eval('col2')) - 1
buf = vim.current.buffer

try:
    selected = buf[start:end + 1]
    start_keep = selected[0][:col1]
    end_keep = selected[-1][(col2 + 1):]
    selected[-1] = selected[-1][:(col2 + 1)]
    selected[0] = selected[0][col1:]

    jsonText = "\n".join(selected)

    parsed = json.loads(jsonText)
    formatted = json.dumps(parsed, indent=4, sort_keys=True) 
    replaced_lines = start_keep + formatted + end_keep

    lines = replaced_lines.split("\n")
    buf[:] = buf[:start] + lines + buf[end + 1:]

except Exception, e:
    print e
EOF

endfunction
