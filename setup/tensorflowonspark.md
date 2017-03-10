#   tensorflow 源码安装:
     
##  一.  安装所有必备工具:
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    rpm -ivh epel-release-latest-6.noarch.rpm
    wget https://copr.fedorainfracloud.org/coprs/pypa/pypa/repo/epel-6/pypa-pypa-epel-6.repo
    mv pypa-pypa-epel-6.repo /etc/yum.repos.d/
    yum makecache
    yum install -y python-devel numpy scipy swig python-pip python-virtualenv python-wheel
     
##  二. 安装 CUDA (在 Linux 上开启 GPU 支持)
    TensorFlow 的 GPU 特性只支持 NVidia Compute Capability >= 3.5 的显卡,下载并安装 Cuda Toolkit 7.0:
    cuda download link:https://developer.nvidia.com/cuda-downloads
    wget http://developer.download.nvidia.com/compute/cuda/repos/fedora21/x86_64/cuda-repo-fedora21-7.0-28.x86_64.rpm
    rpm -ivh cuda-repo-fedora21-7.0-28.x86_64.rpm
    yum makecache
    下载并安装 Cuda Toolkit 7.0
    yum -y install cuda-toolkit-7-0
    解压并拷贝 CUDNN 文件到 Cuda Toolkit 7.0 安装路径下. 假设 Cuda Toolkit 7.0 安装 在 /usr/local/cuda, 执行以下命令:
    tar xvzf cudnn-6.5-linux-x64-v2.tgz
    sudo cp cudnn-6.5-linux-x64-v2/cudnn.h /usr/local/cuda/include
    sudo cp cudnn-6.5-linux-x64-v2/libcudnn* /usr/local/cuda/lib64
     
##  三. 安装 Bazel
    Download bazel-<VERSION>-dist.zip
    wget https://github.com/bazelbuild/bazel/releases/download/0.4.4/bazel-0.4.4-dist.zip
    配置 TensorFlow 的 Cuda 选项
     从源码树的根路径执行:
     $ ./configure
     Do you wish to bulid TensorFlow with GPU support? [y/n] y
     GPU support will be enabled for TensorFlow

     Please specify the location where CUDA 7.0 toolkit is installed. Refer to
     README.md for more details. [default is: /usr/local/cuda]: /usr/local/cuda

     Please specify the location where CUDNN 6.5 V2 library is installed. Refer to
     README.md for more details. [default is: /usr/local/cuda]: /usr/local/cuda

     Setting up Cuda include
     Setting up Cuda lib64
     Setting up Cuda bin
     Setting up Cuda nvvm
     Configuration finished
     这些配置将建立到系统 Cuda 库的符号链接. 每当 Cuda 库的路径发生变更时, 必须重新执行上述 步骤, 否则无法调用 bazel 编译命令.
     编译目标程序, 开启 GPU 支持
     从源码树的根路径执行:
     $ bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer

     $ bazel-bin/tensorflow/cc/tutorials_example_trainer --use_gpu
    大量的输出信息. 这个例子用 GPU 迭代计算一个 2x2 矩阵的主特征值 (major eigenvalue).
    最后几行输出和下面的信息类似.
    ```
     000009/000005 lambda = 2.000000 x = [0.894427 -0.447214] y = [1.788854 -0.894427]
     000006/000001 lambda = 2.000000 x = [0.894427 -0.447214] y = [1.788854 -0.894427]
     000009/000009 lambda = 2.000000 x = [0.894427 -0.447214] y = [1.788854 -0.894427]
     ```
     注意, GPU 支持需通过编译选项 "--config=cuda" 开启.
     已知问题
     尽管可以在同一个源码树下编译开启 Cuda 支持和禁用 Cuda 支持的版本, 我们还是推荐在 在切换这两种不同的编译配置时, 使用 "bazel clean" 清理环境.
     在执行 bazel 编译前必须先运行 configure, 否则编译会失败并提示错误信息. 未来, 我们可能考虑将 configure 步骤包含在编译过程中, 以简化整个过程, 前提是 bazel 能够提供新的特性支持这样.
           
##  四. 建立一个全新的 virtualenv 环境. 为了将环境建在 ~/tensorflow 目录下, 执行:
     virtualenv --system-site-packages ~/tensorflow
     激活 virtualenv
     source bin/activate
     (tensorflow)$ # 终端提示符应该发生变化
         
##  五. 在 virtualenv 内, 安装 TensorFlow:
     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"
     export CUDA_HOME=/usr/local/cuda

     克隆 TensorFlow 仓库
     $ git clone --recurse-submodules https://github.com/tensorflow/tensorflow
     --recurse-submodules 参数是必须得, 用于获取 TesorFlow 依赖的 protobuf 库.
     cd tensorflow/models/image/mnist
     python convolutional.py

     当使用完 TensorFlow
     tensorflow)$ deactivate # 停用 virtualenv
     $ # 你的命令提示符会恢复原样
