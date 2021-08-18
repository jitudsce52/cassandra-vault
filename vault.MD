INSM0007:cassandra-vault jitendra_kumar$ helm3 install vault --namespace=vault charts/ -f override-config/va^C
INSM0007:cassandra-vault jitendra_kumar$ helm3 repo add hashicorp https://helm.releases.hashicorp.com
"hashicorp" already exists with the same configuration, skipping
INSM0007:cassandra-vault jitendra_kumar$ helm search repo hashicorp/vault
No results found
INSM0007:cassandra-vault jitendra_kumar$ helm3 search repo hashicorp/vault
NAME           	CHART VERSION	APP VERSION	DESCRIPTION
hashicorp/vault	0.14.0       	1.8.0      	Official HashiCorp Vault Chart
INSM0007:cassandra-vault jitendra_kumar$ helm install vault hashicorp/vault --version=0.14.0 --namespace=vault -f override-config/vault-override.yaml
Error: could not find tiller
INSM0007:cassandra-vault jitendra_kumar$ helm3 install vault hashicorp/vault --version=0.14.0 --namespace=vault -f override-config/vault-override.yaml
NAME: vault
LAST DEPLOYED: Wed Aug 18 19:53:57 2021
NAMESPACE: vault
STATUS: deployed
REVISION: 1
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get manifest vault
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault get pods
NAME                                    READY   STATUS              RESTARTS   AGE
vault-0                                 0/1     ContainerCreating   0          19s
vault-agent-injector-6f886c6c6c-c62vt   1/1     Running             0          19s
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault get pods
NAME                                    READY   STATUS              RESTARTS   AGE
vault-0                                 0/1     ContainerCreating   0          25s
vault-agent-injector-6f886c6c6c-c62vt   1/1     Running             0          25s
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault rollout status statefulset vault
error: rollout status is only available for RollingUpdate strategy type
INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault get pods
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 0/1     Running   0          68s
vault-agent-injector-6f886c6c6c-c62vt   1/1     Running   0          68s
INSM0007:cassandra-vault jitendra_kumar$



INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault exec $(kubectl -n vault get pods -l app.kubernetes.io/name=vault -o=jsonpath="{.items[0].metadata.name}") -- vault operator init
Unseal Key 1: DbPQRT4+3na9t7h6thAWwr1VvUh8arLdDZG/4R0tLPZ9
Unseal Key 2: AbopURPs4TqAPxNAypdCbU7bL2JWFXud8tH8cqpa28VQ
Unseal Key 3: 7yzaQl4MxNbXwbdeRpNukj6j2yeIxJ8keRjsXsDqFAO3
Unseal Key 4:  9+GqKK8zqfqjf8hCOLCXfZ517jHsHIrkTAogzWCWzRRp
Unseal Key 5: UZfp9TV+tUnk5ccFgx2A583rW9UTsZsjVmSgZjiQs1E/

Initial Root Token: s.V2CpLI157glXwCPePLFYvqpW

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 keys to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
INSM0007:cassandra-vault jitendra_kumar$



INSM0007:cassandra-vault jitendra_kumar$ kubectl -n vault exec -it $(kubectl -n vault get pods -l app.kubernetes.io/name=vault -o=jsonpath="{.items[0].metadata.name}") -- sh
/ $ vault operator unseal DbPQRT4+3na9t7h6thAWwr1VvUh8arLdDZG/4R0tLPZ9
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       d8165421-6983-6b51-4b2c-e1b53c0f7f0e
Version            1.8.0
Storage Type       file
HA Enabled         false
/ $
/ $ vault operator unseal AbopURPs4TqAPxNAypdCbU7bL2JWFXud8tH8cqpa28VQ
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       d8165421-6983-6b51-4b2c-e1b53c0f7f0e
Version            1.8.0
Storage Type       file
HA Enabled         false
/ $
/ $ vault operator unseal 7yzaQl4MxNbXwbdeRpNukj6j2yeIxJ8keRjsXsDqFAO3
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.8.0
Storage Type    file
Cluster Name    vault-cluster-6d557575
Cluster ID      4543467e-1c66-498a-1303-d197ddef420e
HA Enabled      false
/ $
/ $ vault operator unseal 9+GqKK8zqfqjf8hCOLCXfZ517jHsHIrkTAogzWCWzRRp
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.8.0
Storage Type    file
Cluster Name    vault-cluster-6d557575
Cluster ID      4543467e-1c66-498a-1303-d197ddef420e
HA Enabled      false
/ $
/ $ vault operator unseal UZfp9TV+tUnk5ccFgx2A583rW9UTsZsjVmSgZjiQs1E/
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.8.0
Storage Type    file
Cluster Name    vault-cluster-6d557575
Cluster ID      4543467e-1c66-498a-1303-d197ddef420e
HA Enabled      false
/ $


/ $ vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.V2CpLI157glXwCPePLFYvqpW
token_accessor       oYYGo6cN8kmOc5GeFgqIKtwG
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]

/ $ vault auth enable kubernetes
Success! Enabled kubernetes auth method at: kubernetes/
/ $

/ $ vault write auth/kubernetes/config \
>     token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
>     kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
>     kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
Success! Data written to: auth/kubernetes/config

/ $ vault secrets enable database
Success! Enabled the database secrets engine at: database/


/ $ vault write database/config/my-cassandra-database \
>     plugin_name="cassandra-database-plugin" \
>     hosts=cassandra-headless.cassandra \
>     protocol_version=4 \
>     username=vaultuser \
>     password=vaultpass \
>     allowed_roles="*"
/ $


/ $ vault read database/config/my-cassandra-database
Key                                   Value
---                                   -----
allowed_roles                         [*]
connection_details                    map[hosts:cassandra-headless.cassandra protocol_version:4 username:vaultuser]
password_policy                       n/a
plugin_name                           cassandra-database-plugin
root_credentials_rotate_statements    []


/ $ vault write database/roles/my-role \
>    db_name=my-cassandra-database \
>    creation_statements="CREATE USER '{{username}}' WITH PASSWORD '{{password}}' NOSUPERUSER; \
>          GRANT SELECT ON ALL KEYSPACES TO {{username}};" \
>    default_ttl="1h" \
>    max_ttl="24h"
Success! Data written to: database/roles/my-role



/ $ vault read database/roles/my-role
Key                      Value
---                      -----
creation_statements      [CREATE USER '{{username}}' WITH PASSWORD '{{password}}' NOSUPERUSER;          GRANT SELECT ON ALL KEYSPACES TO {{username}};]
db_name                  my-cassandra-database
default_ttl              1h
max_ttl                  24h
renew_statements         []
revocation_statements    []
rollback_statements      []


/ $ vault read database/creds/my-role
Key                Value
---                -----
lease_id           database/creds/my-role/QH6J2BNLxHSGQwgHajhxcECv
lease_duration     1h
lease_renewable    true
password           APDHZAy1AEI-MRdRaOU5
username           v_root_my_role_vmazlep3y9talbni069y_1629289526

/ $ cat /tmp/web-dynamic.hcl
path "database/creds/my-role" {
  capabilities = ["read"]
}

/ $ vault policy write web-dynamic /tmp/web-dynamic.hcl
Success! Uploaded policy: web-dynamic

vault write auth/kubernetes/role/web \
  bound_service_account_names=web \
  bound_service_account_namespaces=web-service \
  policies=web-dynamic \
  ttl=1h

INSM0007:~ jitendkubectl -n cassandra exec -it cassandra-2 -- bash
I have no name!@cassandra-2:/$ cqlsh -u cassandra -p spXx0oifp3
Python 2.7 support is deprecated. Install Python 3.6+ or set CQLSH_NO_WARN_PY2 to suppress this message.

Connected to cassandra at 127.0.0.1:9042
[cqlsh 6.0.0 | Cassandra 4.0.0 | CQL spec 3.4.5 | Native protocol v5]
Use HELP for help.
cassandra@cqlsh> list users;

 name                                           | super | datacenters
------------------------------------------------+-------+-------------
                                      cassandra |  True |         ALL
 v_root_my_role_4el3ljoxm79pugsbaglh_1629287650 | False |         ALL
 v_root_my_role_qghu9ewmqcnjuvum0jch_1629286516 | False |         ALL
 v_root_my_role_qiytefczfwjsic9qghiw_1629287250 | False |         ALL
 v_root_my_role_vmazlep3y9talbni069y_1629289526 | False |         ALL
                                      vaultuser | False |         ALL

(6 rows)
