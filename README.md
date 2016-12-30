# Всё сломано подождите

# collectd-reductor
Плагины для отслеживания метрик для Carbon Reductor

# Установка и настройка

На сервере с Carbon Reductor

``` shell
cd /root/
yum -y install collectd
chkconfig --level 345 on
git clone https://github.com/carbonsoft/collectd-reductor
cd collectd-reductor
make install_collectd
```

Настройте отправку метрик на сервер, занимающийся их хранением (откуда их можно брать для анализа, алертинга итд).

``` xml
<Plugin network>
Server "10.50.140.131"
</Plugin>
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
