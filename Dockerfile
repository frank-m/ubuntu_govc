FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y jq && \
    apt-get clean

# Install VMware GOVC to manage vsphere
RUN curl -L $(curl -s https://api.github.com/repos/vmware/govmomi/releases/latest | grep browser_download_url | grep govc_linux_amd64 | cut -d '"' -f 4) | gunzip > /usr/local/bin/govc && \
    chmod +x /usr/local/bin/govc

# Install Terraform for managing Infrastructure as code
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt install terraform -y

# Install Chef workstation for chef management
RUN wget -O chef-workstation_21.2.259-1_amd64.deb https://packages.chef.io/files/stable/chef-workstation/21.2.259/ubuntu/20.04/chef-workstation_21.2.259-1_amd64.deb
RUN dpkg -i chef-workstation_21.2.259-1_amd64.deb
ENV PATH="/opt/chef-workstation/embedded/bin:${PATH}"

# Clean up APT when done.
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]
