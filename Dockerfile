FROM grzcidocker01.infonova.at/admin/ansible-ubuntu14.04-on-build:2.11

# ==> Specify playbook filename;   default = "playbook.yml"
RUN ansible-galaxy install -f -p roles/ -r requirements.yml
RUN ansible-playbook --vault-password-file=".vpass" -i presentation_cloud create-new-coreos-cluster.yml;
RUN ansible-playbook --vault-password-file=".vpass" -i presentation_cloud create-new-mesos-cluster.yml;
RUN ansible-playbook --vault-password-file=".vpass" -i presentation_cloud create-new-services.yml;

CMD [ "ansible-playbook", "--version" ]
