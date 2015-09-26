ln -s /home/damir/data/supervisord.conf  /usr/local/etc/supervisord.conf
ln -sf /home/damir/data/site-enable /etc/nginx/sites-available/site-enable
ln -sf /home/damir/data/site-enable /etc/nginx/sites-enabled/site-enable
/usr/local/bin/supervisord