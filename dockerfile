FROM osrf/ros:humble-desktop

##instalar gazebo
RUN sudo apt-get update
RUN sudo apt-get update
RUN sudo apt-get install -y ignition-fortress
##linkando o apt-get, podemos rodar para instalar os pacotes recomendados para implementar ros-gazebo
RUN sudo apt-get install -y ros-humble-ros-gz

ENV DISPLAY=host.docker.internal:0.0
## teste ros:
## ros2 run turtlesim turtlesim_node
## teste gazebo:
## ign gazebo shapes.sdf ou ign gazebo para o gui
## requer https://sourceforge.net/projects/vcxsrv/ , rodar xlaunch, com display em 0