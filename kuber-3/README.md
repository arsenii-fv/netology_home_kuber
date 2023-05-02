# Домашнее задание к занятию "Как работает сеть в K8S"

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер k8s с установленным сетевым плагином calico

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/)
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy)

-----

### Задание 1. Создать сетевую политику (или несколько политик) для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace app.
4. Создать политики чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешен и запрещен.

```bash
atman@aurora:/data/kuber-final/kuber-3$ kubectl get pods --namespace=app -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP              NODE    NOMINATED NODE   READINESS GATES
backend-5998747998-pfxmr    1/1     Running   0          35m   10.233.66.72    skyn1   <none>           <none>
backend-5998747998-rjlfj    1/1     Running   0          35m   10.233.116.74   skyn2   <none>           <none>
cache-748b48969b-27q5m      1/1     Running   0          34m   10.233.116.77   skyn2   <none>           <none>
cache-748b48969b-9zbwm      1/1     Running   0          34m   10.233.116.76   skyn2   <none>           <none>
cache-748b48969b-mr2hr      1/1     Running   0          34m   10.233.66.74    skyn1   <none>           <none>
frontend-5877f8cb4b-28xf7   1/1     Running   0          35m   10.233.66.73    skyn1   <none>           <none>
frontend-5877f8cb4b-kszkj   1/1     Running   0          35m   10.233.116.75   skyn2   <none>           <none>

atman@aurora:/data/kuber-final/kuber-3$ kubectl exec frontend-5877f8cb4b-28xf7  --namespace=app -- curl backend-sv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - backend-5998747998-pfxmr - 10.233.66.72 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   141  100   141    0     0   1378      0 --:--:-- --:--:-- --:--:-- 47000
atman@aurora:/data/kuber-final/kuber-3$ kubectl exec frontend-5877f8cb4b-28xf7  --namespace=app -- curl cache-sv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0^C


atman@aurora:/data/kuber-final/kuber-3$ kubectl exec backend-5998747998-rjlfj  --namespace=app -- curl frontend-sv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0^C
atman@aurora:/data/kuber-final/kuber-3$ kubectl exec backend-5998747998-rjlfj  --namespace=app -- curl cache-sv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
1WBITT Network MultiTool (with NGINX) - cache-748b48969b-9zbwm - 10.233.116.76 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
00   140  100   140    0     0    349      0 --:--:-- --:--:-- --:--:-- 35000

```
### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md

atman@aurora:/data/kuber-final/kuber-3$ kubectl get pods --namespace=app -o wide

atman@aurora:/data/kuber-final/kuber-3$ kubectl get networkpolicy --namespace=app

kubectl apply -f manifests/np_backend.yml
