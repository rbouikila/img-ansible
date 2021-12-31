FROM alpine:3.14

# Metadata params
ARG ANSIBLE_VERSION=2.10.6
ARG ANSIBLE_LINT_VERSION=5.2.0


RUN apk --update --no-cache add \
        sudo ca-certificates git openssh-client openssl python3 py3-pip py3-cryptography rsync sshpass && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev libffi-dev openssl-dev build-base && \
    pip3 install --upgrade wheel pip cffi && \
    pip3 install ansible-base==${ANSIBLE_VERSION} && \
    pip3 install ansible-lint==${ANSIBLE_LINT_VERSION} && \
    mkdir /ansible && chmod 640 /ansible && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts && \
    echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

WORKDIR /ansible

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
