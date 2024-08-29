FROM osrf/ros:humble-desktop

##instalar gazebo
RUN sudo apt-get update
##RUN sudo apt-get install -y ignition-fortress

##pacotes para compatibilidade humble-gazebo
##RUN sudo apt-get install -y ros-humble-ros-gz

##instalar miscelaneos
RUN sudo apt-get install -y vim
RUN sudo apt-get install -y wget

##copiando arquivos de teste
COPY dockerteste /dockerteste

##coloca o display do docker como o display 0
ENV DISPLAY=host.docker.internal:0.0

## teste ros:
## ros2 run turtlesim turtlesim_node
## teste gazebo:
## ign gazebo shapes.sdf ou ign gazebo para o gui
## no windows requer https://sourceforge.net/projects/vcxsrv/ , rodar xlaunch, com display em 0 
