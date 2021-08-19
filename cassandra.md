### Git clone
```
INSM0007: git clone https://github.com/jitudsce52/cassandra-vault.git
INSM0007:cassandra-vault jitendra_kumar$ git pull
Already up to date.
```

### Kubernetes namespace creation
```
INSM0007:cassandra-vault jitendra_kumar$ export KUBECONFIG=~/.kube/config-infra-eks

INSM0007:cassandra-vault jitendra_kumar$ kubectl create ns vault
namespace/vault created
apiVersion: v2

INSM0007:cassandra-vault jitendra_kumar$ kubectl create ns cassandra
namespace/cassandra created
```

### install cassandra helm chart

```
INSM0007:cassandra-vault jitendra_kumar$ helm install cassandra --namespace=cassandra charts/cassandra/ -f override-config/cassadra-override.yaml
NAME: cassandra
LAST DEPLOYED: Wed Aug 18 19:05:08 2021
NAMESPACE: cassandra
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace cassandra -l "app.kubernetes.io/name=cassandra,app.kubernetes.io/instance=cassandra" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace cassandra $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace cassandra port-forward $POD_NAME 8080:$CONTAINER_PORT

```

### cassandra pod status
```
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n cassandra get pods
NAME          READY   STATUS    RESTARTS   AGE
cassandra-0   0/1     Running   0          33s
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n cassandra rollout status statefulset cassandra
Waiting for 3 pods to be ready...
Waiting for 2 pods to be ready...
Waiting for 1 pods to be ready...
statefulset rolling update complete 3 pods at revision cassandra-6ccd48494d...

INSM0007:cassandra-vault jitendra_kumar$ kubectl -n cassandra get pods
NAME          READY   STATUS    RESTARTS   AGE
cassandra-0   1/1     Running   0          9m55s
cassandra-1   1/1     Running   0          4m45s
cassandra-2   1/1     Running   0          3m14s

```

### Retrieve cassandra superuser's password

```
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n cassandra get secrets cassandra -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'
### cassandra-password
spXx0oifp3
```


### Confirm cassandra root credential
```
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n cassandra exec -it cassandra-0 -- bash
I have no name!@cassandra-0:/$
I have no name!@cassandra-0:/$ cqlsh -u cassandra -p spXx0oifp3
Python 2.7 support is deprecated. Install Python 3.6+ or set CQLSH_NO_WARN_PY2 to suppress this message.

Connected to cassandra at 127.0.0.1:9042
[cqlsh 6.0.0 | Cassandra 4.0.0 | CQL spec 3.4.5 | Native protocol v5]
Use HELP for help.
cassandra@cqlsh> list users;

 name      | super | datacenters
-----------+-------+-------------
 cassandra |  True |         ALL
(1 rows)
```

### Create user for `vault` and grant permisssion

```
cassandra@cqlsh> CREATE USER vaultuser WITH PASSWORD 'vaultpass';
cassandra@cqlsh> list users;

 name      | super | datacenters
-----------+-------+-------------
 cassandra |  True |         ALL
 vaultuser | False |         ALL

(2 rows)
cassandra@cqlsh> GRANT CREATE ON ALL ROLES to 'vaultuser';
cassandra@cqlsh> GRANT ALTER ON ALL ROLES to 'vaultuser';
cassandra@cqlsh> GRANT DROP ON ALL ROLES to 'vaultuser';
cassandra@cqlsh> GRANT AUTHORIZE ON ALL ROLES to 'vaultuser';
cassandra@cqlsh> GRANT all PERMISSIONS ON all KEYSPACES TO 'vaultuser';
cassandra@cqlsh>
```

### create keyspaces and table

```
cassandra@cqlsh> describe keyspaces;

system       system_distributed  system_traces  system_virtual_schema
system_auth  system_schema       system_views

cassandra@cqlsh> CREATE KEYSPACE enployee_keyspace WITH replication ={ 'class': 'SimpleStrategy', 'replication_factor': 3 };
cassandra@cqlsh> describe keyspaces enployee_keyspace;
Improper describe command.
cassandra@cqlsh> describe keyspaces;

enployee_keyspace  system_auth         system_schema  system_views
system             system_distributed  system_traces  system_virtual_schema

cassandra@cqlsh> USE enployee_keyspace;
cassandra@cqlsh:enployee_keyspace> CREATE TABLE employee(
                     ...    emp_id int PRIMARY KEY,
                     ...    emp_name text,
                     ...    emp_city text,
                     ...    emp_sal varint,
                     ...    emp_phone varint
                     ... );

cassandra@cqlsh:enployee_keyspace> DESCRIBE tables;

employee

cassandra@cqlsh:enployee_keyspace> INSERT INTO employee (emp_id, emp_name, emp_city,emp_phone, emp_sal) VALUES(1,'Jitu', 'TOKYO', 50000, 0701112222);
cassandra@cqlsh:enployee_keyspace> INSERT INTO employee (emp_id, emp_name, emp_city,emp_phone, emp_sal) VALUES(2,'Steve', 'NYC', 400000, 0801113331);
cassandra@cqlsh:enployee_keyspace> INSERT INTO employee (emp_id, emp_name, emp_city,emp_phone, emp_sal) VALUES(3,'Fred', 'PERIS', 75000, 0903335552);


cassandra@cqlsh:enployee_keyspace> select * from employee;

 emp_id | emp_city | emp_name | emp_phone | emp_sal
--------+----------+----------+-----------+-----------
      1 |    TOKYO |     Jitu |     50000 | 701112222
      2 |      NYC |    Steve |    400000 | 801113331
      3 |    PERIS |     Fred |     75000 | 903335552

(3 rows)
cassandra@cqlsh:enployee_keyspace>



cassandra@cqlsh:enployee_keyspace> list users;

 name      | super | datacenters
-----------+-------+-------------
 cassandra |  True |         ALL
 vaultuser | False |         ALL

(2 rows)

```
