# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию).
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории.
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
```bash
atman@aurora:/data/kuber-final/kuber-6/terraform$ terraform plan
yandex_vpc_network.zero-net: Refreshing state... [id=enpps3rc9arq6bm2tfvt]
yandex_vpc_subnet.public: Refreshing state... [id=e9b3ga8o427i9muvvnlq]
yandex_vpc_route_table.lab-rt-a: Refreshing state... [id=enpfcjb0kt9547a7r177]
yandex_vpc_subnet.private: Refreshing state... [id=e9buede5v6qu0nj5b5kj]
yandex_compute_instance.public: Refreshing state... [id=fhmkmr2oc6h9aftslri7]
yandex_compute_instance.nat: Refreshing state... [id=fhmcbccvc6und3e63408]
yandex_compute_instance.private: Refreshing state... [id=fhm53ikmup6mu6tie1ct]
No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
atman@aurora:/data/kuber-final/kuber-6/terraform$ terraform apply

atman@aurora:/data/kuber-final/kuber-6/terraform$ ssh aris@51.250.85.254

aris@inst-pub:~$ ping ya.ru
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=58 time=0.731 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=58 time=0.338 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=58 time=0.332 ms
^C
--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2025ms
rtt min/avg/max/mdev = 0.332/0.467/0.731/0.186 ms

aris@inst-pub:~$ ip route
default via 192.168.10.1 dev eth0 proto dhcp src 192.168.10.4 metric 100
192.168.10.0/24 dev eth0 proto kernel scope link src 192.168.10.4
192.168.10.1 dev eth0 proto dhcp scope link src 192.168.10.4 metric 100
```
![Виртуальные машины](/pictures/vm.png)

3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

```bash
aris@inst-pub:~$ ssh aris@192.168.20.4

aris@inst-priv:~$ ping ya.ru
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=58 time=0.611 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=58 time=0.405 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=58 time=0.373 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=4 ttl=58 time=0.333 ms
^C
--- ya.ru ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3036ms
rtt min/avg/max/mdev = 0.333/0.430/0.611/0.109 ms

aris@inst-priv:~$ sudo traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.20.1)  1.225 ms  1.216 ms  1.345 ms
 2  * * *
 3  * * *
 4  100.64.0.101 (100.64.0.101)  2.455 ms  2.371 ms  2.443 ms
 5  * * *
 6  109.239.136.60 (109.239.136.60)  13.452 ms google.msk.piter-ix.net (185.0.12.11)  5.008 ms 185.232.60.148 (185.232.60.148)  19.552 ms
 7  108.170.250.51 (108.170.250.51)  20.818 ms 108.170.250.130 (108.170.250.130)  5.365 ms 108.170.250.51 (108.170.250.51)  20.696 ms
 8  172.253.66.116 (172.253.66.116)  20.697 ms 108.170.250.129 (108.170.250.129)  5.091 ms 216.239.46.254 (216.239.46.254)  4.559 ms
 9  66.249.95.224 (66.249.95.224)  18.690 ms 172.253.65.159 (172.253.65.159)  16.602 ms 142.251.238.68 (142.251.238.68)  19.531 ms
10  72.14.234.54 (72.14.234.54)  45.337 ms 142.250.238.214 (142.250.238.214)  23.358 ms 216.239.49.115 (216.239.49.115)  23.405 ms
11  * * *
12  * 172.253.79.115 (172.253.79.115)  19.231 ms *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * dns.google (8.8.8.8)  18.953 ms
```
![Подсети](/pictures/sky-net.png)
![Таблица маршрутизации](/pictures/route.png)
```bash
atman@aurora:/data/kuber-final/kuber-6/terraform$ terraform destroy -auto-approve
Destroy complete! Resources: 7 destroyed.
```


Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---
### Задание 2. AWS* (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Создать пустую VPC с подсетью 10.10.0.0/16.

resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "lab-subnet-a" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.lab-net.id}"
}

module "vpc" {
  source              = "git@github.com:terraform-yc-modules/terraform-yc-vpc.git"
  network_name        = "netology-network"
  network_description = "Test network created with module"
  private_subnets = [{
    name           = "subnet-1"
    zone           = "ru-central1-b"
    v4_cidr_blocks = ["10.10.0.0/16"]
  }
  ]

2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 10.10.1.0/24.
 - Разрешить в этой subnet присвоение public IP по-умолчанию.
 - Создать Internet gateway.
 - Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
 - Создать security group с разрешающими правилами на SSH и ICMP. Привязать эту security group на все, создаваемые в этом ДЗ, виртуалки.
 - Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться, что есть доступ к интернету.
 - Добавить NAT gateway в public subnet.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 10.10.2.0/24.
 - Создать отдельную таблицу маршрутизации и привязать её к private подсети.
 - Добавить Route, направляющий весь исходящий трафик private сети в NAT.
 - Создать виртуалку в приватной сети.
 - Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети, и убедиться, что с виртуалки есть выход в интернет.

Resource Terraform:

1. [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc).
1. [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet).
1. [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
