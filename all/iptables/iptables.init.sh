#!/bin/bash

# 1. Очистка старых правил и цепочек
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# 2. Установка политик по умолчанию (Блокировать всё)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 3. Разрешить локальный интерфейс (Loopback)
# Это критически важно для работы внутренних сервисов системы
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 4. Разрешить уже установленные и зависимые соединения
# Позволяет серверу отвечать на запросы, которые он сам инициировал
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 5. РАЗРЕШЕННЫЕ ВХОДЯЩИЕ ПОРТЫ (Настройте под себя)

# Разрешить SSH (По умолчанию порт 22. Если вы его изменили, укажите ваш порт)
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# Разрешить Веб-трафик (HTTP и HTTPS) — раскомментируйте, если это веб-сервер
 iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
 iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# Разрешить ICMP (Пинг) — полезно для диагностики (можно отключить при желании)
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# 6. Сохранение правил (зависит от вашего дистрибутива)
# Для Ubuntu/Debian требуется пакет iptables-persistent:
# sudo apt install iptables-persistent
# netfilter-persistent save

# Для CentOS/RHEL/Fedora:
# service iptables save