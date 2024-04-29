FROM gazebo:latest
WORKDIR /src
FROM ros:latest
COPY --from=0 /src .
#atualiza
RUN apt-get update
#instala git
RUN apt-get install -y git
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    tmux \
    xterm \
    xclip \
    python3-pip 
RUN pip install setuptools==58.2.0
RUN pip install transforms3d
CMD []
#rodar "docker build -t (nome_imagem) ." para criar imagem
#rodar "docker volume create (nome_volume)" para criar volume
#rodar "docker run -v (nome_volume) -it (nome_imagem) bash" para acessar console do container
