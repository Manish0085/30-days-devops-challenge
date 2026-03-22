# Day 6 — Log Rotation and Archiving

## Goal
Write a script that automatically compresses old logs, deletes very old logs, and rotates app.log when it exceeds 10MB — exactly what production servers need.

---

## Script Built
**`log_rotation.sh`**

---

## What the Script Does

```
Create backup directory
    ↓
Find logs older than 7 days → compress with gzip → move to backup
    ↓
Find compressed logs older than 30 days → delete
    ↓
Check app.log size → if > 10MB → rename and create fresh log
```

---

## Commands Learned

### Find Command
```bash
# Find files older than N days
find /home/ubuntu -name "*.log" -mtime +7

# find          = search for files
# -name "*.log" = only .log files (quotes required!)
# -mtime +7     = modified more than 7 days ago
# -mtime -7     = modified less than 7 days ago
# -mtime 7      = modified exactly 7 days ago
```

### Process Multiple Files with While Loop
```bash
find "$LOG_DIR" -name "*.log" -mtime +$COMPRESS_DAYS | while read file; do
    gzip "$file"
    mv "$file.gz" "$BACKUP_DIR/"
done

# pipe | while read file = process each result one by one
# safer than for loop — handles spaces in filenames
```

### Compress Files
```bash
gzip file.log        # Creates file.log.gz, removes original
gzip -k file.log     # Creates file.log.gz, keeps original
gunzip file.log.gz   # Decompress
```

### Delete Files
```bash
find "$BACKUP_DIR" -name "*.gz" -mtime +30 | while read file; do
    rm -rf "$file"
done
```

### Check File Size
```bash
wc -c < app.log      # Returns file size in bytes
# < redirects file as input — cleaner output (no filename)
```

### Rotate Log File
```bash
MAX_LOG_SIZE=10485760   # 10MB in bytes

file_size=$(wc -c < "$APP_LOG")
if [[ $file_size -gt $MAX_LOG_SIZE ]]; then
    mv "$APP_LOG" "app.log.$(date +%Y-%m-%d)"   # Rename with date
    touch "$APP_LOG"                              # Create fresh empty log
fi
```

### Simulate Old Files for Testing
```bash
touch -d "10 days ago" /home/ubuntu/test-old.log    # Create file with old date
touch -d "35 days ago" /home/ubuntu/very-old.log
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| `find -mtime +N` | Files older than N days |
| `while read file` | Process each file from find one by one |
| `gzip` | Compress file — reduces size significantly |
| `wc -c < file` | File size in bytes |
| `touch -d "N days ago"` | Create file with old modification date (testing) |
| `tr -d '%'` | Remove character from output |
| `$(date +%Y-%m-%d)` | Current date in YYYY-MM-DD format |
| Log rotation | Rename old log, create fresh one — prevents huge files |

---

## Errors Faced & Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| find not matching files | Missing quotes around `*.log` | Used `"*.log"` with quotes |
| File not getting created after rotation | Used `mkdir` instead of `touch` | Changed to `touch "$APP_LOG"` |
| Wrong files being deleted | Missing `+` in `-mtime $DELETE_DAYS` | Changed to `-mtime +$DELETE_DAYS` |

---

## How to Run

```bash
bash log_rotation.sh
```
