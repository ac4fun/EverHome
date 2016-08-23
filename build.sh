#!/bin/bash
mkdir deps &> /dev/null
cd deps

#Add necessary extra repos
version=$(lsb_release -a 2>&1)
if [[ $version == *"14.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb
    #rm cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl
    sudo apt-get update
    sudo apt-get install -y libpcl-all
elif [[ $version == *"15.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1504/x86_64/cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1504_7.5-18_amd64.deb
    #rm cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo apt-get update
    sudo apt-get install -y libpcl-dev yasm libvtk5-qt4-dev
else
    echo "Don't use this on anything except 14.04 or 15.04"
    exit
fi

sudo apt-get install -y libeigen3-dev libboost1.55-dev cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev openjdk-7-jdk freeglut3-dev python-vtk libvtk-java libglew-dev cuda-7-5 libsuitesparse-dev libvtk6-dev libqhull-dev
sudo apt-get install cmake

wget http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.zip
unzip flann-1.8.4-src.zip
cd flann-1.8.4-src

mkdir build
cd build
cmake ..
make
sudo make install

cd ../..



# Build OpenNI1
sudo apt-get install libusb-1.0-0-dev freeglut3-dev openjdk-7-jdk doxygen graphviz mono-complete
git clone https://github.com/OpenNI/OpenNI
cd OpenNI/Platform/Linux/CreateRedist/
./RedisMaker
cd 
cd ../Redist/OpenNI-Bin-Dev-Linux-x64-v1.5.7.10
sudo ./install.sh
cd ../../../../../

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
cd pcl-pcl-1.6.0
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release .. 
make 
sudo make install

