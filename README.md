# deploy
  
# Introdução  
Este repositório contém arquivos e Actions relacionados à utilização, coordenação e uso de projetos ROS no ambiente Docker, e também de instalações de software utilizando Ansible Playbooks  

# Conteúdo  

- dockerfile   
- compose.yaml   
- playbook.yaml   
- Actions  

# Dependências
- Linux
  
## Para Dockerfile
- Docker Engine (https://docs.docker.com/engine/install/ubuntu/)
## Para Playbook   
Modo mais comum e fácil de instalação:
```
apt-get install ansible
```
- Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)  
# Utilização
## Package
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
```yaml
FROM ros:humble ##imagem base, tudo após isso são mudanças exclusivas a imagem final

RUN apt-get update ##atualiza o apt-get

##instalar miscelaneos
RUN sudo apt-get install -y vim wget ##RUN funciona igual rodar um comando usando a linha de comando 
RUN sudo apt-get install -y tty-clock 

##copiando arquivos de teste
COPY dockerteste /dockerteste ##COPY cria uma cópia dos arquivos locais para dentro da imagem
RUN chmod +x /dockerteste/testesROS/rodar-testes.sh

##faz build do projeto e altera o diretorio inicial
WORKDIR /dockerteste ##WORKDIR muda o diretorio inicial da imagem 
RUN rosdep install -i --from-path . --rosdistro humble -y && \
    colcon build

```
## Docker Compose  
O Docker Compose possibilita a coordenação de vários containers de forma centralizada, permitindo uma maior facilidade em integrar diferentes containers.   
O compose.yaml disponível demonstra como algo deste tipo funciona/é possível:
```yaml
services: ## cada servico (container) que o compose deve subir

  talker1: ##exemplo de um servico

    build: . ##atualmente utiliza uma dockerfile presente no diretório para criar uma imagem, e logo após a utiliza para criar o container do servico
    ##image: ghcr.io/fei-s-r/deploy:main ##este comando utilizará a imagem hosteada no repositório deploy como a base deste servico, especificamente a imagem baseada na main
    container_name: talker1 ##nome utilizado para identificar o container
    restart: always ##politica de reinicializacao, atualmente sempre tenta reiniciar quando o servico cair
    command: bash -c "source install/setup.bash && ros2 run py_pubsub talker --ros-args -p number:=1" ##comando que roda imediatamente quando o servico sobe

  talker2:
    build: .
    ##image: ghcr.io/fei-s-r/deploy:main
    container_name: talker2
    restart: always
    command: bash -c "source install/setup.bash && ros2 run py_pubsub talker --ros-args -p number:=2"

  listener:
    build: .
    ##image: ghcr.io/fei-s-r/deploy:main
    container_name: listener
    restart: always
    command: bash -c "source install/setup.bash && ros2 run py_pubsub listener"
  
```
## Playbook  
O playbook ansible criado permite a rápida e consistente instalação das dependências necessárias para rodar o ROS2 Humble na máquina local  
### Aviso! ROS2 Humble atualmente precisa de Linux Jammy 22.04, o playbook irá dar um erro antes de instalar qualquer coisa, caso este não seja o sistema operacional
Tendo o ansible instalado, é possível rodar o playbook pelo seguinte comando:
```
ansible-playbook playbook.yaml
```
## Actions    
O repositório possui 2 Actions, um para upload da imagem em main, e outra para upload e testes em staging
# Workflow Main
Esta Action é acionada quando há algum push para Main, construindo a imagem e fazendo upload desta para ghcr.io/fei-s-r/main
# Workflow staging
Esta Action é acionada quando há algum push para staging, construindo a imagem, rodando o compose e rodando comandos de testes presentes ambos no Action,
como também presentes em arquivos para facilitar testes, sendo possível rodar arquivos .sh dentro dos containers do compose. O actions também loga as saídas do compose, as transformando em um arquivo
que pode ser baixado posteriormente.
```yaml
      - name: compose ##inicia o compose e redireciona logs do compose para um arquivo logs.txt 
        run: |
          docker compose -f compose.yaml up -d
          docker compose logs -f > logs.txt &

      - name: teste ##roda o .sh chamado rodar-testes.sh dentro do container de nome listener
        run: docker exec listener bash -c "cd /dockerteste/testesROS && ./rodar-testes.sh"
        
      - name: logs ##mostra os containers ainda ativos
        run: |
          docker compose ps
          
          
      - name: upload dos logs ##faz upload dos logs como um arquivo no job do Action
        uses: actions/upload-artifact@v4
        with:
          name: docker-logs
          path: logs.txt
```
# Plano:

Juntar ROS e Gazebo  :shipit:    
Implementar adicionar arquivos de repositório no container :shipit:   
Docker Compose :shipit:  
Playbook Ansible :shipit:  
Automatizar testes usando Github Actions (CI) :shipit:  
Criar Documentação :x:

Opcional:
Testar diferenças de desempenho entre um robô utilizando containers Docker e um rodando nativamente :x:  
