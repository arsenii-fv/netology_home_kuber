# Домашнее задание к занятию "Troubleshooting"

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить.

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

```bash
atman@aurora:/data/kuber-final/kuber-5$ kubectl apply -f files/task.yaml
Error from server (NotFound): error when creating "files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "files/task.yaml": namespaces "data" not found

atman@aurora:/data/kuber-final/kuber-5$ kubectl apply -f files/ns_web.yml
atman@aurora:/data/kuber-final/kuber-5$ kubectl apply -f files/ns_data.yml

atman@aurora:/data/kuber-final/kuber-5$ kubectl  get pods  -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS          AGE
kube-system   csi-nfs-controller-f9bd9cfc-26ccf          3/3     Running   165 (8m37s ago)   43d
kube-system   csi-nfs-node-zq84h                         3/3     Running   165 (8m37s ago)   43d
kube-system   calico-node-trpjq                          1/1     Running   1 (8m37s ago)     6d5h
kube-system   coredns-6f5f9b5d74-pkxdk                   1/1     Running   7 (8m37s ago)     45d
kube-system   calico-kube-controllers-6f464c69cf-64pgv   1/1     Running   1 (8m37s ago)     6d5h
kube-system   hostpath-provisioner-69cd9ff5b8-9dchk      1/1     Running   5 (8m37s ago)     42d
web           web-consumer-577d47b97d-547k7              1/1     Running   0                 44s
web           web-consumer-577d47b97d-j9m7p              1/1     Running   0                 44s
data          auth-db-795c96cddc-r75bh                   1/1     Running   0                 44s
```
1. При создании подов, появилось сообщение о не найденных namespaces: web, data
2. Создал namespaces: web, data
### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
