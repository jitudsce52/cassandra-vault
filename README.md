# cassandra-vault
HashiCorp Vault Integration With Apache Cassandra


### Cassandra and vault setup in kubernetes
# Helm chart can be found in charts/
# chart hashicorp/vault
```
helm fetch --untar hashicorp/vault
```
# chart cassandra is is manually created.
```
basic test for cassandra chart.
helm lint chart/cassandra
helm template chart/cassandra

```

### For Cassandra and vault setup kindly follow cassandra.md and vault.md

### Please find cassandra chart README.MD file at chart/cassandra/

### Web application status and db credential mount 
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

### cassandra user
```
$ cqlsh -u cassandra -p spXx0oifp3
/usr/local/bin/cqlsh:466: DeprecationWarning: Legacy execution parameters will be removed in 4.0. Consider using execution profiles.
/usr/local/bin/cqlsh:490: DeprecationWarning: Setting the consistency level at the session level will be removed in 4.0. Consider using execution profiles and setting the desired consitency level to the EXEC_PROFILE_DEFAULT profile.
Connected to cassandra at 127.0.0.1:9042
[cqlsh 6.0.0 | Cassandra 4.0.0 | CQL spec 3.4.5 | Native protocol v5]
Use HELP for help.
cassandra@cqlsh> list users;

 name                                                      | super | datacenters
-----------------------------------------------------------+-------+-------------
                                                 cassandra |  True |         ALL
 v_kubernetes_web__my_role_u2t1n6ifvbpghzbd8b1s_1629311774 | False |         ALL
                                                 vaultuser | False |         ALL

```