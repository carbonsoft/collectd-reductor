all:
	# Установите, набрав команды:
	# 	make install
	# 	service collectd restart
install_collectd:
	mkdir -p /etc/collectd.d/
	mkdir -p /usr/lib64/collectd/plugins/
	cp -av etc/collectd.d/* /etc/collectd.d/
	cp -av usr/lib64/collectd/plugins/* /usr/lib64/collectd/plugins/
install_telegraf:
	rm -rf /etc/telegraf/telegraf.d/plugins
	cp -a  etc/telegraf/telegraf.d/plugins /etc/telegraf/telegraf.d/plugins
