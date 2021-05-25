Mac下的安装和使用:[https://www.jianshu.com/p/f456f414bb3b](https://www.jianshu.com/p/f456f414bb3b)
* 环境变量
Anaconda 安装好后，会自动在 ~/.bash_profile 中添加 anaconda 的环境变量
`source ~/.bash_profile `即可启用
* 查看包含环境信息(星号表示当前激活的环境):
       ` conda info -e`
* 激活环境
    `    conda activate  xxxxxx`
* 创建环境
      ` conda create --name xxx python=xxx`
* Conda错误：Collecting package metadata (current_repodata.json): failed
conda新安装设置清华源后发现并没有使用，且会出现错误
Collecting package metadata (current_repodata.json): failed
换了科大源也没成功，考虑可能是默认源的问题，删除.condarc文件中的defaults后可以正常使用清华源。
还有可能报错failed with initial frozen solve. Retrying with flexible solve.
这个错误不影响执行，可以通过以下设置解决：`conda config --set channel_priority flexible`
*解决Anaconda出现CondaHTTPError: HTTP 000 CONNECTION FAILED for url问题[https://blog.csdn.net/Copper01/article/details/97134974](https://blog.csdn.net/Copper01/article/details/97134974)

