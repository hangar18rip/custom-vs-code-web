FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common curl gnome-keyring && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main' | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install gh -y


RUN wget -O- https://aka.ms/install-vscode-server/setup.sh | sh

RUN mkdir /startup
COPY launch.ps1 /startup
RUN mkdir /vscode-server-datadir

# Creating the user and usergroup
ARG USERNAME=vscode

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USERNAME -m -s /bin/bash $USERNAME 
    # \ && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME 
    # \ && chmod 0440 /etc/sudoers.d/$USERNAME

RUN chown -R $USERNAME:$USERNAME /vscode-server-datadir && \
    chmod +x /vscode-server-datadir
RUN chown -R $USERNAME:$USERNAME /startup && \
    chmod +x /startup

USER vscode

EXPOSE 8000

ENTRYPOINT [ "/bin/pwsh", "-File", "/startup/launch.ps1" ]