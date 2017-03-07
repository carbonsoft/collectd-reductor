# collectd-reductor
Плагины для отслеживания метрик для Carbon Reductor

# Установка и настройка

На сервере с Carbon Reductor:

``` shell
cd /root/
yum -y install collectd
chkconfig --level 345 collectd on
git clone https://github.com/carbonsoft/collectd-reductor
cd collectd-reductor
make install_collectd
```

Настройте отправку метрик на сервер, занимающийся их хранением (откуда их можно брать для анализа, алертинга итд).

В файле: `/etc/collectd.conf`:

``` xml
<Plugin network>
Server "10.50.140.131"
</Plugin>
```
В нём же исправьте строчку:

```
Include "/etc/collectd.d/"
```

на

```
Include "/etc/collectd.d/*.conf"
```

После чего запустите:

```
service collectd restart
```

# Какие метрики собираются

- Число загруженных URL/доменов
- Число элементов в внутренней базе данных (важно в основном для разработки)
- Число проверенных пакетов
- Число срабатываний модулей
- Состояние активации

# Для версии ниже 7.5.1 110 / 8.00.07

Выпуск версии с исправлением временно заморожен.

Для того, чтобы всё заработало нужно:

Carbon Reductor 7:

``` shell
cp -a hotfix/collectd_plugin /usr/local/Reductor/bin/collectd_plugin
cp -a hotfix/modules_ctl /usr/local/Reductor/bin/modules_ctl
```

Carbon Reductor 8:

``` shell
cp -a hotfix/collectd_plugin /app/reductor/usr/local/Reductor/bin/collectd_plugin
cp -a hotfix/modules_ctl /app/reductor/usr/local/Reductor/bin/modules_ctl
```
