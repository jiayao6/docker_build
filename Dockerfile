FROM ufoym/deepo:caffe-py27
ADD opencv-3.2.0.zip /tmp/
ADD FindCUDA.cmake /tmp/
ADD OpenCVDetectCUDA.cmake /tmp/
ADD common.hpp /tmp/
RUN apt update -y && \
  apt install -y cmake libboost-dev libboost-thread-dev libboost-filesystem-dev python-tk python-dev libxml2-dev libxslt-dev libboost-python-dev pkg-config python-numpy unzip && \
  unzip /tmp/opencv-3.2.0.zip && \
  mv opencv-3.2.0 opencv
RUN cp -f /tmp/FindCUDA.cmake opencv/cmake/FindCUDA.cmake && \
  cp -f /tmp/OpenCVDetectCUDA.cmake opencv/cmake/OpenCVDetectCUDA.cmake && \
  cp -f /tmp/common.hpp opencv/modules/cudev/include/opencv2/cudev/common.hpp
RUN cd opencv && mkdir release && cd release && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D FORCE_VTK=ON -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_OPENGL=ON -D WITH_CUBLAS=ON -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" -D WITH_GDAL=ON -D WITH_XINE=ON -D BUILD_EXAMPLES=OFF .. && \
  make -j8 &&   make install -j8 &&   cd ../.. && rm -rf opencv && rm /tmp/opencv-3.2.0.zip && rm -rf /tmp/* && \
  apt autoremove && apt autoclean
ENV  PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig