# 使用官方的 Ubuntu 镜像作为基础镜像
FROM debian:latest

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
  git \
  zsh \
  which \
  vim \
  curl \
  tree \
  htop


# 设置环境变量以确保使用 UTF-8 编码
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 设置默认 shell 为 zsh
RUN chsh -s /bin/zsh root



# 安装 nvm
ENV NVM_DIR /root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 Node.js 并设置默认版本
RUN bash -c "source $NVM_DIR/nvm.sh && \
  nvm install --lts && \
  nvm alias default lts/* && \
  nvm use default"

# 安装 Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  chsh -s $(which zsh)


# 安装 zsh-autosuggestions 和 zsh-syntax-highlighting 插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 写入 .zshrc 文件
RUN echo 'export ZSH="/root/.oh-my-zsh"' > /root/.zshrc && \
  echo 'ZSH_THEME="robbyrussell"' >> /root/.zshrc && \
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> /root/.zshrc && \
  echo 'source $ZSH/oh-my-zsh.sh' >> /root/.zshrc


# 配置 nvm
RUN echo '' >> /root/.zshrc && \
  echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc && \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.zshrc && \
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.zshrc


# 安装 npm, yarn 和 pnpm
RUN bash -c "source $NVM_DIR/nvm.sh && \
  npm install -g npm && \
  npm install -g yarn && \
  npm install -g pnpm"

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 到工作目录
# COPY package*.json ./

# 安装项目依赖
RUN bash -c "source $NVM_DIR/nvm.sh"

# 复制项目文件到工作目录
# COPY . .


# 运行时挂载 .ssh 目录
VOLUME ["/root/.ssh"]
# 暴露端口
# EXPOSE 3308 8082 3000

# 启动应用
# CMD ["zsh", "-c", "source $NVM_DIR/nvm.sh && pnpm install && pnpm start"]

# 保持容器运行
CMD ["tail", "-f", "/dev/null"]