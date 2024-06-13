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

# 设置默认 shell 为 zsh
SHELL ["/bin/zsh", "-c"]

# 安装 nvm
ENV NVM_DIR /root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 Node.js 并设置默认版本
RUN bash -c "source $NVM_DIR/nvm.sh && \
  nvm install --lts && \
  nvm alias default lts/* && \
  nvm use default"

# 安装 Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 设置 Oh My Zsh 主题 (例如 "agnoster" 主题)
# RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc


# 配置 zshrc
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
# WORKDIR /app

# 复制 package.json 和 package-lock.json 到工作目录
# COPY package*.json ./

# 安装项目依赖
# RUN bash -c "source $NVM_DIR/nvm.sh"

# 复制项目文件到工作目录
# COPY . .

# 暴露端口
# EXPOSE 3000

# 启动应用
# CMD ["zsh", "-c", "source $NVM_DIR/nvm.sh && pnpm install && pnpm start"]

# 保持容器运行
CMD ["tail", "-f", "/dev/null"]