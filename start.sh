ln -s /home/damir/data/run/supervisord.conf  /usr/local/etc/supervisord.conf
ln -sf /home/damir/data/run/site-enable /etc/nginx/sites-available/site-enable
ln -sf /home/damir/data/run/site-enable /etc/nginx/sites-enabled/site-enable
/usr/local/bin/supervisord