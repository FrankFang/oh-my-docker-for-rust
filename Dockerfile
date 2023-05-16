FROM archlinux:base-20230430.0.146624

WORKDIR /tmp
ENV SHELL /bin/bash
ADD mirrorlist /etc/pacman.d/mirrorlist
RUN yes | pacman -Syu
RUN yes | pacman -S git zsh which vim curl tree htop
RUN mkdir -p /root/.config
VOLUME [ "/root/.config", "/root/repos", "/root/.vscode-server/extensions", "/var/lib/docker", "/root/.ssh" ]
# end

# z
ADD z /root/.z_jump
# end

# zsh
RUN zsh -c 'git clone https://code.aliyun.com/412244196/prezto.git "$HOME/.zprezto"' &&\
	  zsh -c 'setopt EXTENDED_GLOB' &&\
	  zsh -c 'for rcfile in "$HOME"/.zprezto/runcoms/z*; do ln -s "$rcfile" "$HOME/.${rcfile:t}"; done'
ENV SHELL /bin/zsh
# end


# tools
RUN yes | pacman -S fzf openssh exa the_silver_searcher fd rsync &&\
		ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key &&\
		ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key
# end

# fq
ADD proxychains.conf /root/.config/proxychains.conf
RUN yes | pacman -S trojan proxychains-ng
# end

# others
RUN yes | pacman -S postgresql-libs
# end

# dotfiles
ADD bashrc /root/.bashrc
RUN echo '[ -f /root/.bashrc ] && source /root/.bashrc' >> /root/.zshrc; \
    echo '[ -f /root/.zshrc.local ] && source /root/.zshrc.local' >> /root/.zshrc
RUN mkdir -p /root/.config; \
    touch /root/.config/.profile; ln -s /root/.config/.profile /root/.profile; \
    touch /root/.config/.gitconfig; ln -s /root/.config/.gitconfig /root/.gitconfig; \
    touch /root/.config/.zsh_history; ln -s /root/.config/.zsh_history /root/.zsh_history; \
    touch /root/.config/.z; ln -s /root/.config/.z /root/.z; \
    touch /root/.config/.rvmrc; ln -s /root/.config/.rvmrc /root/.rvmrc; \
    touch /root/.config/.bashrc; ln -s /root/.config/.bashrc /root/.bashrc.local; \
    touch /root/.config/.zshrc; ln -s /root/.config/.zshrc /root/.zshrc.local;
RUN git config --global core.editor "code --wait"; \
    git config --global init.defaultBranch main
# end

# Rust
RUN echo 'export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup' >> ~/.bash_profile; \
    echo 'export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup' >> ~/.bash_profile
RUN yes | pacman -S gcc
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN echo 'source "$HOME/.cargo/env"' >> /root/.zshrc
RUN /root/.cargo/bin/rustup default stable
