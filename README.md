# deploy

# Introdução  
Este repositório contém arquivos e Actions relacionados à utilização, coordenação e uso de projetos ROS no ambiente Docker, e também de instalações de software utilizando Ansible Playbooks  

# Conteúdo  

- dockerfile
- playbook.yaml
- compose.yaml
- Actions  

# Dependências
- Linux
  
## Para Dockerfile
- Docker Engine (https://docs.docker.com/engine/install/ubuntu/)
## Para Playbook
- Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)  
# Utilização
## Package !!! Falta adicionar o github login para tokens da organização!!
É necessário a autenticação das credenciais no docker para poder fazer o pull das imagens!
```
docker login ghcr.io
```
Logo depois informando um username e uma Access Token com acesso às packages da organização 
```
Username: usernamequalquer
Password: AccessToken
```
  
As Packages deste repositório são imagens hosteadas em ghcr.io (Repositório de Imagens do Github), automaticamente contruídas baseadas no conteúdo das branches, o uso delas sendo visado a facilitar a sua utilização  
Por Exemplo:
### Para a imagem principal localizada na branch main:
```
docker pull ghcr.io/fei-s-r/deploy:main
```
### Para a imagem de teste localizada na branch staging
```
docker pull ghcr.io/fei-s-r/deploy:staging
```
## Dockerfile
A dockerfile contém todas as intruções de instalações de dependências e configurações da imagem, o arquivo pode ser modificado para adicionar ou remover dependências  
Por Exemplo, adicionar tty-clock para a imagem:
```
FROM ros:humble

RUN apt-get update

##instalar miscelaneos
RUN sudo apt-get install -y vim wget tty-clock

##copiando arquivos de teste
COPY dockerteste /dockerteste
RUN chmod +x /dockerteste/testesROS/rodar-testes.sh

##faz build do projeto e altera o diretorio inicial
WORKDIR /dockerteste
RUN rosdep install -i --from-path . --rosdistro humble -y && \
    colcon build

```
## Playbook  

# Plano:

Juntar ROS e Gazebo  :shipit:    
Implementar adicionar arquivos de repositório no container :shipit:   
Docker Compose :shipit:  
Playbook Ansible :shipit:  
Automatizar testes usando Github Actions (CI) :shipit:  
Criar Documentação :x:

Opcional:
Testar diferenças de desempenho entre um robô utilizando containers Docker e um rodando nativamente :x:  
