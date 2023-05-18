# Домашнее задание к занятию "Обновление приложений"

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/)

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор.

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Какую стратегию обновления выберете и почему?
```
Recreate разом заменив старые pods, т.к. нет совместимости использования старого и нового приложения
```
### Задание 2. Обновить приложение.

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Кол-во реплик - 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.
```
atman@aurora:/data/kuber-final/kuber-4$ kubectl get pods
NAME                                      READY   STATUS              RESTARTS   AGE
nginx-multy-deployment-68cc8cb859-dzqln   2/2     Running             0          7m11s
nginx-multy-deployment-68cc8cb859-58sj9   2/2     Running             0          7m1s
nginx-multy-deployment-68cc8cb859-l4hbk   2/2     Running             0          6m59s
nginx-multy-deployment-68cc8cb859-zwkwx   2/2     Running             0          6m56s
nginx-multy-deployment-7d8db9c99f-tb72h   0/2     ContainerCreating   0          4s
nginx-multy-deployment-7d8db9c99f-n6fjv   0/2     ContainerCreating   0          4s
atman@aurora:/data/kuber-final/kuber-4$ kubectl get pods
NAME                                      READY   STATUS         RESTARTS   AGE
nginx-multy-deployment-68cc8cb859-dzqln   2/2     Running        0          7m49s
nginx-multy-deployment-68cc8cb859-58sj9   2/2     Running        0          7m39s
nginx-multy-deployment-68cc8cb859-l4hbk   2/2     Running        0          7m37s
nginx-multy-deployment-68cc8cb859-zwkwx   2/2     Running        0          7m34s
nginx-multy-deployment-7d8db9c99f-n6fjv   1/2     ErrImagePull   0          42s
nginx-multy-deployment-7d8db9c99f-tb72h   1/2     ErrImagePull   0          42s

atman@aurora:/data/kuber-final/kuber-4$ kubectl rollout undo deployment nginx-multy-deployment --to-revision=3
atman@aurora:/data/kuber-final/kuber-4$ kubectl get deployment -o wide
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS                IMAGES                               SELECTOR
nginx-multy-deployment   5/5     5            5           3h46m   nginx,network-multitool   nginx:1.19,wbitt/network-multitool   app=nginx-multy

Можно откатиться, заменив в deployment версию nginx на рабочую, без kubectl rollout undo.
```

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию.

### Задание 3*. Создать Canary deployment.

1. Создать 2 deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать 2 версии приложения (веб-страницы).
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
