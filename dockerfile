FROM osrf/ros:humble-desktop

##instalar gazebo
RUN sudo apt-get install lsb-release wget gnupg
RUN sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install ignition-fortress
##linkando o apt-get, podemos rodar para instalar os pacotes recomendados para implementar ros-gazebo
RUN sudo apt-get install ros-humble-ros-gz

ENV DISPLAY=host.docker.internal:0.0
## teste ros ros2 turtlesim turtlesim_node
## teste gazebo ign gazebo shapes.sdf ou ign gazebo para o gui
## requer https://sourceforge.net/projects/vcxsrv/ , rodar xlaunch, com display em 0