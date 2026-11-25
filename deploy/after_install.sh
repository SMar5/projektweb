#!/usr/bin/env bash
set -euo pipefail
APP=/opt/nforum/current
VENV=/opt/nforum/venv
PY="$VENV/bin/python"
[ -d "$VENV" ] || python3 -m venv "$VENV"
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet -r "$APP/app/requirements.txt"
# with_env.py wczytuje sekrety z SSM Parameter Store i uruchamia komendę
cd "$APP/app"
"$PY" "$APP/deploy/with_env.py" "$PY" manage.py migrate --noinput
"$PY" "$APP/deploy/with_env.py" "$PY" manage.py collectstatic --noinput
cat > /etc/systemd/system/nforum.service <<UNIT
[Unit]
Description=NForum (gunicorn)
After=network-online.target
Wants=network-online.target
[Service]
User=nforum
Group=nforum
WorkingDirectory=$APP/app
ExecStart=$PY $APP/deploy/with_env.py $VENV/bin/gunicorn nforum.wsgi:application \\
  --bind 0.0.0.0:8000 --workers 3 --timeout 30 \\
  --access-logfile - --error-logfile -
Restart=on-failure
RestartSec=3
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable nforum
chown -R nforum:nforum /opt/nforum