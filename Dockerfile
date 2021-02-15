FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl jq git && \
    apt-get clean

# Install VMware GOVC to manage vsphere
RUN curl -L $(curl -s https://api.github.com/repos/vmware/govmomi/releases/latest | grep browser_download_url | grep govc_linux_amd64 | cut -d '"' -f 4) | gunzip > /usr/local/bin/govc && \
    chmod +x /usr/local/bin/govc

# Install Terraform for managing Infrastructure as code
RUN curl -L https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip | gunzip > /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/terraform
    
# Install Chef workstation for chef management
RUN curl --output chef-workstation_21.2.259-1_amd64.deb https://packages.chef.io/files/stable/chef-workstation/21.2.259/ubuntu/20.04/chef-workstation_21.2.259-1_amd64.deb
RUN dpkg -i chef-workstation_21.2.259-1_amd64.deb
ENV PATH="/opt/chef-workstation/embedded/bin:${PATH}"

# Clean up APT when done.
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]
