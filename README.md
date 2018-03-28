# collectd-reductor

Плагины для отслеживания метрик для Carbon Reductor.

В текущем виде не рекомендуются к использованию в продакшне, только для отладки при разработке. Для продакшна нужно снизить интервал опроса в 10 раз.

# Установка и настройка

На сервере с Carbon Reductor:

``` shell
cd /root/
yum -y install collectd git
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

## Подробнее

Метрики отсылаются в формате:

```
PUTVAL хост/модуль/gauge-метрика время:значение
```

### Модуль HTTP-матчинга (ipt_reductor):

- activation_error: 0 - всё в порядке, 1 - ошибка
- database - то что загружено в память модуля
  - buffer - промежуточная база данных
  - readonly - используемая база данных
  - urls - загруженные в базу URL
  - elements - элементы на которые дробится URL при добавлении в базу URL
- packets
  - matched - число срабатываний модуля
  - checked - число проверенных пакетов
  - skipped - число проигнорированных из-за лицензии пакетов

```
PUTVAL reductor_stand/ipt_reductor/gauge-activation_error 1490010353:0
PUTVAL reductor_stand/ipt_reductor/gauge-database_buffer_urls 1490010353:69791
PUTVAL reductor_stand/ipt_reductor/gauge-database_readonly_urls 1490010353:69791
PUTVAL reductor_stand/ipt_reductor/gauge-database_buffer_elements 1490010353:89564
PUTVAL reductor_stand/ipt_reductor/gauge-database_readonly_elements 1490010353:89564
PUTVAL reductor_stand/ipt_reductor/gauge-packets_matched 1490010353:1
PUTVAL reductor_stand/ipt_reductor/gauge-packets_checked 1490010353:16068546
PUTVAL reductor_stand/ipt_reductor/gauge-packets_skipped 1490010353:0
```

### Модуль DNS-матчинга (ipt_dnsmatch):

Всё абсолютно то же самое, что и в ipt_reductor, только вместо URL домены.

- packets_slowpath - число DNS-пакетов, для проверки которых приходилось дополнительно выделять память. Таких пакетов пока замечено не было.

```
PUTVAL reductor_stand/ipt_dnsmatch/gauge-activation_error 1490010353:0
PUTVAL reductor_stand/ipt_dnsmatch/gauge-database_buffer_domains 1490010353:18369
PUTVAL reductor_stand/ipt_dnsmatch/gauge-database_readonly_domains 1490010353:18369
PUTVAL reductor_stand/ipt_dnsmatch/gauge-database_buffer_elements 1490010353:19849
PUTVAL reductor_stand/ipt_dnsmatch/gauge-database_readonly_elements 1490010353:19849
PUTVAL reductor_stand/ipt_dnsmatch/gauge-packets_matched 1490010353:633179
PUTVAL reductor_stand/ipt_dnsmatch/gauge-packets_checked 1490010353:8696581
PUTVAL reductor_stand/ipt_dnsmatch/gauge-packets_skipped 1490010353:0
PUTVAL reductor_stand/ipt_dnsmatch/gauge-packets_slowpath 1490010353:0
PUTVAL reductor_stand/ipt_snimatch/gauge-activation_error 1490010353:0
```

### Модуль HTTPS-матчинга (ipt_snimatch):

Всё то же самое, что и у ipt_dnsmatch и ipt_reductor.

- packets-ambigous - не удалось определить размер TCP-заголовка стандартными средствами ядра Linux. Приводит к более медленному срабатыванию и дополнительной (но незначительной) нагрузке на сервер.
- packets-nonlinear и packets-notmatched - служебная статистика для разработчиков, нужна для отслеживания ситуаций, которые не должны никак происходить.

```
PUTVAL reductor_stand/ipt_snimatch/gauge-database_buffer_domains 1490010353:18368
PUTVAL reductor_stand/ipt_snimatch/gauge-database_readonly_domains 1490010353:18368
PUTVAL reductor_stand/ipt_snimatch/gauge-database_buffer_elements 1490010353:19754
PUTVAL reductor_stand/ipt_snimatch/gauge-database_readonly_elements 1490010353:19754
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_matched 1490010353:0
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_notmatched 1490010353:2842349
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_ambigous 1490010353:2842310
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_nonlinear 1490010353:0
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_checked 1490010353:2842344
PUTVAL reductor_stand/ipt_snimatch/gauge-packets_skipped 1490010353:0
```

### Сигнатуры и списки

- signatures - размер списка сигнатур, нужных модулю ipt_reductor
- lists
  - rkn - то, что было извлечено из реестра, без дополнительной обработки
  - load - то, что было обработано Carbon Reductor: агрегировано, модифцировано и т.д. Это то, что реально используется для фильтрации.

Подробную документацию по тому, какой список чем является можно посмотреть в [документации Carbon Reductor](http://docs.carbonsoft.ru/pages/viewpage.action?pageId=51380431)

```
PUTVAL reductor_stand/reductor_cache/gauge-signatures 1490010353:71854
PUTVAL reductor_stand/lists/gauge-rkn.url_http 1490010353:57193
PUTVAL reductor_stand/lists/gauge-rkn.ip_port 1490010353:9
PUTVAL reductor_stand/lists/gauge-rkn.domain_mask 1490010353:139
PUTVAL reductor_stand/lists/gauge-rkn.url_https 1490010353:4233
PUTVAL reductor_stand/lists/gauge-rkn.domain_exact 1490010353:17205
PUTVAL reductor_stand/lists/gauge-rkn.port_http 1490010353:6
PUTVAL reductor_stand/lists/gauge-rkn.ip_https_plus 1490010353:8200
PUTVAL reductor_stand/lists/gauge-rkn.port_https 1490010353:2
PUTVAL reductor_stand/lists/gauge-rkn.ip_https 1490010353:38
PUTVAL reductor_stand/lists/gauge-rkn.ip_block 1490010353:1434
PUTVAL reductor_stand/lists/gauge-rkn.domain_proxy 1490010353:1034
PUTVAL reductor_stand/lists/gauge-rkn.url_unknown 1490010353:0
PUTVAL reductor_stand/lists/gauge-load.ip_block 1490010353:1438
PUTVAL reductor_stand/lists/gauge-load.ip_https_plus 1490010353:10973
PUTVAL reductor_stand/lists/gauge-load.url_hsts 1490010353:2035
PUTVAL reductor_stand/lists/gauge-load.url_http 1490010353:69791
PUTVAL reductor_stand/lists/gauge-load.port_https 1490010353:2
PUTVAL reductor_stand/lists/gauge-load.ip6_https_plus 1490010353:1640
PUTVAL reductor_stand/lists/gauge-load.domain_mask 1490010353:18365
PUTVAL reductor_stand/lists/gauge-load.ip6_port 1490010353:0
PUTVAL reductor_stand/lists/gauge-load.port_http 1490010353:6
PUTVAL reductor_stand/lists/gauge-load.ip_https 1490010353:38
PUTVAL reductor_stand/lists/gauge-load.url_https 1490010353:7800
PUTVAL reductor_stand/lists/gauge-load.ip_port 1490010353:9
PUTVAL reductor_stand/lists/gauge-load.ip6_https 1490010353:0
PUTVAL reductor_stand/lists/gauge-load.domain_hsts 1490010353:1
PUTVAL reductor_stand/lists/gauge-load.ip6_block 1490010353:0
```

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

