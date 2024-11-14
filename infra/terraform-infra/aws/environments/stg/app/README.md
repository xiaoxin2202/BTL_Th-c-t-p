step1: $ cd ../scs-devops/infra/terraform-infra/spc/environments/stg-dr/app

step2: $ terraform init -migrate-state

step3: $ terraform plan

step4: $ terraform apply


---------------------------------------------------------------------------------------------
[deployment APP in ADM]
download: $ sudo aws s3 sync s3://spc-terraform-state/ansible  /etc/ansible --endpoint https://s3.ap-northeast-1.samsungspc.com
push ansible: $ sudo aws s3 sync /etc/ansible s3://spc-terraform-state/ansible  --endpoint https://s3.ap-northeast-1.samsungspc.com
get host: $ sudo bash /etc/ansible/create_hosts.sh

SCA: change endpoint DB, user, password
$ sudo nano /etc/ansible/roles/sca/defaults/main.yml
$ ansible-playbook playbooks/sca.yml

PRS: change endpoint DB, user, password
$ sudo nano /etc/ansible/roles/presence/defaults/main.yml
$ ansible-playbook playbooks/presence.yml

RLA: change endpoint DB, user, password
$ sudo nano /etc/ansible/roles/relay/defaults/main.yml
$ ansible-playbook playbooks/relay.yml

STUN: change endpoint DB, user, password
$ sudo nano /etc/ansible/roles/stun/defaults/main.yml
$ ansible-playbook playbooks/stun.ymlyes
