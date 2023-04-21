# Домашнее задание к занятию "Установка Kubernetes"

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развернутые ВМ с ОС Ubuntu 20.04-lts


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
2. [Документация kubespray](https://kubespray.io/)

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.
```bash
atman@aurora:~$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epda9kb2turobv0t0mlc | master  | ru-central1-b | RUNNING | 154.201.10.199 | 10.129.0.34 |
| epde3uobal513abb4q11 | skyn2   | ru-central1-b | RUNNING | 84.241.143.201 | 10.129.0.27 |
| epdjq5jcek91oqabeeuc | skyn1   | ru-central1-b | RUNNING | 84.205.151.251 | 10.129.0.5  |
| epdkj5s8kbin8mhpdqgu | skyn3   | ru-central1-b | RUNNING | 58.50.184.74   | 10.129.0.28 |
+----------------------+---------+---------------+---------+----------------+-------------+



tman@aurora:/data/kuber-final/kuber-2/kubespray$ kubectl get nodes -o wide
NAME     STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master   Ready    control-plane   51m   v1.26.3   10.129.0.34   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn1    Ready    <none>          50m   v1.26.3   10.129.0.27   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn2    Ready    <none>          50m   v1.26.3   10.129.0.5    <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn3    Ready    <none>          50m   v1.26.3   10.129.0.28   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0

atman@aurora:/data/kuber-final/kuber-2/kubespray$ kubectl get nodes
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   48m   v1.26.3
skyn1    Ready    <none>          47m   v1.26.3
skyn2    Ready    <none>          47m   v1.26.3
skyn3    Ready    <none>          47m   v1.26.3
```
## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию.

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA
2. Использовать нечетное кол-во Master-node
3. Для cluster ip использовать keepalived или другой способ
```bash
atman@aurora:~$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epd6opnailjn41717vim | master3 | ru-central1-b | RUNNING | 51.250.111.221 | 10.129.0.21 |
| epda9kb2turobv0t0mlc | master1 | ru-central1-b | RUNNING | 84.201.140.199 | 10.129.0.29 |
| epde3uobal513abb4q11 | skyn2   | ru-central1-b | RUNNING | 84.201.141.246 | 10.129.0.7  |
| epdjq5jcek91oqabeeuc | skyn1   | ru-central1-b | RUNNING | 84.201.161.254 | 10.129.0.18 |
| epdkj5s8kbin8mhpdqgu | skyn3   | ru-central1-b | RUNNING | 51.250.18.74   | 10.129.0.6  |
| epdkjh1nlo4vejkoev8u | master2 | ru-central1-b | RUNNING | 51.250.101.95  | 10.129.0.8  |
+----------------------+---------+---------------+---------+----------------+-------------+


atman@aurora:/data/kuber-final/kuber-2/kubespray$ kubectl get nodes -o wide
NAME      STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master1   Ready    control-plane   11h   v1.26.3   10.129.0.29   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
master2   Ready    control-plane   11h   v1.26.3   10.129.0.8    <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
master3   Ready    control-plane   11h   v1.26.3   10.129.0.21   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn1     Ready    <none>          11h   v1.26.3   10.129.0.18   <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn2     Ready    <none>          11h   v1.26.3   10.129.0.7    <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0
skyn3     Ready    <none>          11h   v1.26.3   10.129.0.6    <none>        Ubuntu 20.04.6 LTS   5.4.0-146-generic   containerd://1.7.0

atman@aurora:/data/kuber-final/kuber-2/kubespray$ kubectl get pods -A -o wide
NAMESPACE     NAME                                      READY   STATUS    RESTARTS       AGE   IP              NODE      NOMINATED NODE   READINESS GATES
kube-system   calico-kube-controllers-6dfcdfb99-cvcm5   1/1     Running   1 (139m ago)   13h   10.233.66.66    skyn1     <none>           <none>
kube-system   calico-node-59d4w                         1/1     Running   1 (140m ago)   13h   10.129.0.21     master3   <none>           <none>
kube-system   calico-node-7j78f                         1/1     Running   1 (139m ago)   13h   10.129.0.18     skyn1     <none>           <none>
kube-system   calico-node-g4plh                         1/1     Running   1 (139m ago)   13h   10.129.0.8      master2   <none>           <none>
kube-system   calico-node-kv4wh                         1/1     Running   2 (138m ago)   13h   10.129.0.6      skyn3     <none>           <none>
kube-system   calico-node-spc9r                         1/1     Running   1 (139m ago)   13h   10.129.0.7      skyn2     <none>           <none>
kube-system   calico-node-xsc7x                         1/1     Running   1 (139m ago)   13h   10.129.0.29     master1   <none>           <none>
kube-system   coredns-645b46f4b6-72vms                  1/1     Running   1 (140m ago)   13h   10.233.72.2     master3   <none>           <none>
kube-system   coredns-645b46f4b6-p2czc                  1/1     Running   1 (139m ago)   13h   10.233.104.66   master1   <none>           <none>
kube-system   dns-autoscaler-65d5b47988-t7d7q           1/1     Running   1 (139m ago)   13h   10.233.116.2    master2   <none>           <none>
kube-system   kube-apiserver-master1                    1/1     Running   2 (139m ago)   13h   10.129.0.29     master1   <none>           <none>
kube-system   kube-apiserver-master2                    1/1     Running   1 (139m ago)   13h   10.129.0.8      master2   <none>           <none>
kube-system   kube-apiserver-master3                    1/1     Running   2 (140m ago)   13h   10.129.0.21     master3   <none>           <none>
kube-system   kube-controller-manager-master1           1/1     Running   4 (102m ago)   13h   10.129.0.29     master1   <none>           <none>
kube-system   kube-controller-manager-master2           1/1     Running   5 (139m ago)   13h   10.129.0.8      master2   <none>           <none>
kube-system   kube-controller-manager-master3           1/1     Running   4 (138m ago)   13h   10.129.0.21     master3   <none>           <none>
kube-system   kube-proxy-9t2l7                          1/1     Running   0              97m   10.129.0.8      master2   <none>           <none>
kube-system   kube-proxy-dtkbc                          1/1     Running   0              97m   10.129.0.21     master3   <none>           <none>
kube-system   kube-proxy-dxkx6                          1/1     Running   0              97m   10.129.0.6      skyn3     <none>           <none>
kube-system   kube-proxy-g558b                          1/1     Running   0              97m   10.129.0.18     skyn1     <none>           <none>
kube-system   kube-proxy-whjm8                          1/1     Running   0              97m   10.129.0.29     master1   <none>           <none>
kube-system   kube-proxy-zvgh4                          1/1     Running   0              97m   10.129.0.7      skyn2     <none>           <none>
kube-system   kube-scheduler-master1                    1/1     Running   3 (102m ago)   13h   10.129.0.29     master1   <none>           <none>
kube-system   kube-scheduler-master2                    1/1     Running   3 (139m ago)   13h   10.129.0.8      master2   <none>           <none>
kube-system   kube-scheduler-master3                    1/1     Running   3 (138m ago)   13h   10.129.0.21     master3   <none>           <none>
kube-system   nginx-proxy-skyn1                         1/1     Running   1 (139m ago)   13h   10.129.0.18     skyn1     <none>           <none>
kube-system   nginx-proxy-skyn2                         1/1     Running   1 (139m ago)   13h   10.129.0.7      skyn2     <none>           <none>
kube-system   nginx-proxy-skyn3                         1/1     Running   1 (139m ago)   13h   10.129.0.6      skyn3     <none>           <none>
kube-system   nodelocaldns-4sjmq                        1/1     Running   1 (140m ago)   13h   10.129.0.21     master3   <none>           <none>
kube-system   nodelocaldns-82sf5                        1/1     Running   2 (137m ago)   13h   10.129.0.18     skyn1     <none>           <none>
kube-system   nodelocaldns-wkrkw                        1/1     Running   1 (139m ago)   13h   10.129.0.7      skyn2     <none>           <none>
kube-system   nodelocaldns-xdrmd                        1/1     Running   2 (139m ago)   13h   10.129.0.6      skyn3     <none>           <none>
kube-system   nodelocaldns-z5tzb                        1/1     Running   1 (139m ago)   13h   10.129.0.8      master2   <none>           <none>
kube-system   nodelocaldns-zz4k8                        1/1     Running   2 (138m ago)   13h   10.129.0.29     master1   <none>           <none>

atman@aurora:~$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epd6opnailjn41717vim | master3 | ru-central1-b | RUNNING | 51.250.111.221 | 10.129.0.21 |
| epda9kb2turobv0t0mlc | master1 | ru-central1-b | STOPPED | 84.201.140.199 | 10.129.0.29 |
| epde3uobal513abb4q11 | skyn2   | ru-central1-b | RUNNING | 84.201.141.246 | 10.129.0.7  |
| epdjq5jcek91oqabeeuc | skyn1   | ru-central1-b | RUNNING | 84.201.161.254 | 10.129.0.18 |
| epdkj5s8kbin8mhpdqgu | skyn3   | ru-central1-b | RUNNING | 51.250.18.74   | 10.129.0.6  |
| epdkjh1nlo4vejkoev8u | master2 | ru-central1-b | RUNNING | 51.250.101.95  | 10.129.0.8  |
+----------------------+---------+---------------+---------+----------------+-------------+

atman@aurora:~$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epd6opnailjn41717vim | master3 | ru-central1-b | RUNNING | 51.250.111.221 | 10.129.0.21 |
| epda9kb2turobv0t0mlc | master1 | ru-central1-b | STOPPED | 84.201.140.199 | 10.129.0.29 |
| epde3uobal513abb4q11 | skyn2   | ru-central1-b | RUNNING | 84.201.141.246 | 10.129.0.7  |
| epdjq5jcek91oqabeeuc | skyn1   | ru-central1-b | RUNNING | 84.201.161.254 | 10.129.0.18 |
| epdkj5s8kbin8mhpdqgu | skyn3   | ru-central1-b | RUNNING | 51.250.18.74   | 10.129.0.6  |
| epdkjh1nlo4vejkoev8u | master2 | ru-central1-b | STOPPED | 51.250.101.95  | 10.129.0.8  |
+----------------------+---------+---------------+---------+----------------+-------------+
yc-user@master3:~$ ping  10.129.0.129
PING 10.129.0.129 (10.129.0.129) 56(84) bytes of data.
64 bytes from 10.129.0.129: icmp_seq=1 ttl=64 time=0.053 ms

yc-user@master3:~$ curl 10.129.0.129:6443
Client sent an HTTP request to an HTTPS server.

```


### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
