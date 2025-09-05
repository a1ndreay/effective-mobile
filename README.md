# Инструкция по инсталяции скрипта

1. Скопируйте скрипт 'monitoring.sh' в директорию '/usr/local/bin' и сделайте скрипт исполняемым
```bash
cp monitoring.sh /usr/local/bin && chmod +x /usr/local/bin/monitoring.sh
```
2. Скопируйте test-monitoring.service и test-monitoring.timer в /etc/systemd/system/
```
cp test* /etc/systemd/system && systemctl daemon-reload
```
3. Включите и запустите таймер:
```
systemctl enable --now test-monitoring.timer
```
