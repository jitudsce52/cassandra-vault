# cassandra-vault
HashiCorp Vault Integration With Apache Cassandra

```
INSM0007:DevOps jitendra_kumar$ kubectl -n web-service get pods
NAME                             READY   STATUS    RESTARTS   AGE
web-deployment-78598ff48-7j2t8   2/2     Running   0          116s
web-deployment-78598ff48-tbdk7   2/2     Running   0          103s
INSM0007:DevOps jitendra_kumar$ kubectl -n web-service exec -it web-deployment-78598ff48-tbdk7 -- cat /vault/secrets/db-creds
Defaulting container name to web.
Use 'kubectl describe pod/web-deployment-78598ff48-tbdk7 -n web-service' to see all of the containers in this pod.
{
"db_connection": "host=cassandra-headless.cassandra user=v_kubernetes_web__my_role_u2t1n6ifvbpghzbd8b1s_1629311774 password=AtEFzu6YywK-hdfvSvLY"
}
```