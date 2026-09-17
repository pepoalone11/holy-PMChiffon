#!/usr/bin/env bash
set -e

# Pass arguments to python script
python3 - "$@" << 'PYEOF'
import sys
import os
import json
import urllib.request
from datetime import datetime, timezone

webhook_file = "/Users/teerawat/holy-PMChiffon/.discord_webhook"
if not os.path.exists(webhook_file):
    webhook_file = os.path.expanduser("~/.gemini/.discord_webhook")

if not os.path.exists(webhook_file):
    sys.stderr.write(f"Error: Webhook file not found at {webhook_file}\n")
    sys.exit(1)

with open(webhook_file, "r") as f:
    webhook_url = f.read().strip()

if not webhook_url:
    sys.stderr.write("Error: Webhook URL is empty\n")
    sys.exit(1)

version_tag = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else datetime.now().strftime("v%Y.%m.%d-%H%M")
skills_list = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2] else "• ตรวจสอบและซิงค์ข้อมูลตามรอบเวลา"
commit_hash = sys.argv[3] if len(sys.argv) > 3 and sys.argv[3] else "HEAD"
short_hash = commit_hash[:7]

rollback_cmd = f"git -C /Users/teerawat/holy-PMChiffon checkout {version_tag} -- config/skills && cp -r /Users/teerawat/holy-PMChiffon/config/skills/* ~/.gemini/config/skills/"
timestamp = datetime.now(timezone.utc).isoformat()

payload = {
    "username": "Holy PMChiffon",
    "avatar_url": "https://raw.githubusercontent.com/pepoalone11/holy-PMChiffon/main/assets/avatar.png",
    "embeds": [
        {
            "title": "🚀 Holy PMChiffon — Skills Synced & Tagged!",
            "description": "สำรองข้อมูล Skills และสร้าง Version Tag ขึ้น GitHub สำเร็จเรียบร้อย",
            "color": 65340,
            "fields": [
                {
                    "name": "🏷️ Version Tag",
                    "value": f"`{version_tag}`",
                    "inline": True
                },
                {
                    "name": "🔗 Commit",
                    "value": f"[`{short_hash}`](https://github.com/pepoalone11/holy-PMChiffon/commit/{commit_hash})",
                    "inline": True
                },
                {
                    "name": "📦 Updated Skills",
                    "value": skills_list,
                    "inline": False
                },
                {
                    "name": "💡 Rollback Command",
                    "value": f"```bash\n{rollback_cmd}\n```",
                    "inline": False
                }
            ],
            "footer": {
                "text": "Holy PMChiffon Auto-Sync System"
            },
            "timestamp": timestamp
        }
    ]
}

data = json.dumps(payload).encode("utf-8")
req = urllib.request.Request(
    webhook_url,
    data=data,
    headers={
        "Content-Type": "application/json",
        "User-Agent": "HolyPMChiffon/1.0"
    },
    method="POST"
)

try:
    with urllib.request.urlopen(req) as resp:
        if 200 <= resp.status < 300:
            print(f"✅ Discord notification sent successfully (HTTP {resp.status})")
        else:
            sys.stderr.write(f"⚠️ Unexpected response (HTTP {resp.status})\n")
            sys.exit(1)
except urllib.error.HTTPError as e:
    sys.stderr.write(f"⚠️ Discord webhook HTTP error: {e.code} - {e.read().decode('utf-8')}\n")
    sys.exit(1)
except Exception as e:
    sys.stderr.write(f"⚠️ Discord webhook error: {e}\n")
    sys.exit(1)
PYEOF
