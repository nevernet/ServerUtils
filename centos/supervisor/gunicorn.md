```
pip install gunicorn
```

```
/root/.pyenv/shims/gunicorn application.wsgi -b 0.0.0.0:8000
```

```
[program:demo-project]
directory=/opt/www/demo-project
command=/root/.pyenv/shims/gunicorn application.wsgi -b 0.0.0.0:8000
autostart = true
autorestart=true
startsecs = 5
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdoiut_logfile_backups = 5
stdout_logfile = /var/log/supervisord/demo-project.log
stdout_logfile_maxbytes=30MB
stdout_logfile_backups=2
```
