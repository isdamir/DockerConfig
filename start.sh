sudo ln /home/damir/data/supervisord.conf  /usr/local/etc/supervisord.conf>/dev/null 2>&1
sudo ln -sf /home/damir/data/site-enable /etc/nginx/sites-available/site-enable>/dev/null 2>&1
sudo ln -sf /home/damir/data/site-enable /etc/nginx/sites-enabled/site-enable>/dev/null 2>&1
/usr/local/bin/supervisord