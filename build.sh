#!/bin/bash

mkdir deps
cd deps

sudo apt-get install libeigen3-dev libboost1.55-dev

wget http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.zip
unzip flann-1.8.4-src.zip
mkdir build
cd build
cmake ..
make
sudo make install

sudo apt-get install libvtk6-dev libqhull-dev

# Build OpenNI1
sudo apt-get install libusb-1.0-0-dev freeglut3-dev openjdk-7-jdk doxygen graphviz mono-complete
git clone https://github.com/OpenNI/OpenNI
cd Platform/Linux/CreateRedist/
./RedisMaker
cd ../Redist/OpenNI-Bin-Dev-Linux-x64-v1.5.7.10
sudo ./install.sh

sudo apt-get install -y cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev openjdk-7-jdk freeglut3-dev python-vtk libvtk-java libglew-dev libsuitesparse-dev



#Building OpenCV from scratch without Qt and with nonfree
wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.9/opencv-2.4.9.zip
unzip opencv-2.4.9.zip
#rm opencv-2.4.9.zip
cd opencv-2.4.9
mkdir build
cd build
cmake -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_OPENCL=OFF -D WITH_OPENMP=ON -D INSTALL_C_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_OPENGL=OFF -D WITH_VTK=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF ..
make -j8
sudo make install
echo "/usr/local/lib" | sudo tee -a /etc/ld.so.conf.d/opencv.conf
sudo ldconfig
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" | sudo tee -a /etc/bash.bashrc
echo "export PKG_CONFIG_PATH" | sudo tee -a /etc/bash.bashrc
source /etc/bash.bashrc
cd ../..


wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.6.0.tar.gz
tar -xzvf pcl-1.6.0.tar.gz
cd pcl-1.6.0
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release .. 
make 
sudo make install

