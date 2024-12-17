FROM osrf/ros:humble-desktop

##instalar gazebo
RUN sudo apt-get update
##RUN sudo apt-get install -y ignition-fortress

##pacotes para compatibilidade humble-gazebo
##RUN sudo apt-get install -y ros-humble-ros-gz

##instalar miscelaneos
RUN sudo apt-get install -y vim
RUN sudo apt-get install -y wget

##copiando arquivos de teste e dependencias
COPY dockerteste /dockerteste
RUN chmod +x /dockerteste/testesROS/rodar-testes.sh
RUN rosdep install --from-paths /dockerteste --ignore-src -r -y
##declarando o source, para nao ter que fazer em toda inicializacao de terminal bash
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /dockerteste/install/setup.bash" >> ~/.bashrc

##coloca o display do docker como o display 0
##ENV DISPLAY=host.docker.internal:0.0

## teste ros (precisa de display):
## ros2 run turtlesim turtlesim_node

