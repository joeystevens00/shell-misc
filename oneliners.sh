# Recursively watch /var/log for the text fail or failed
find /var/log/ -name "*.log" -exec ls {} \; 2>/dev/null | xargs tail -qf {} 2>/dev/null | egrep -i "fail|failed"
