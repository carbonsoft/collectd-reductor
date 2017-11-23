all:
	# Установите, набрав команды:
	# 	make install
	# 	service collectd restart
install_collectd:
	# now plugins are shipped with reductor
	mkdir -p /etc/collectd.d/
	rm -f /etc/collectd.d/reductor.conf
	rm -f /etc/collectd.d/dnsmatch.conf
	rm -f /etc/collectd.d/snimatch.conf
	rm -f /usr/lib64/collectd/plugins/*
	cp -av etc/collectd.d/* /etc/collectd.d/
install_telegraf:
	rm -rf /etc/telegraf/telegraf.d/plugins
	cp -a  etc/telegraf/telegraf.d/plugins /etc/telegraf/telegraf.d/plugins
	usermod -a -G telegraf wheel
