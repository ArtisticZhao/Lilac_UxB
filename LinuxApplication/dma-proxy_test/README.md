# 罪己诏

`dma-proxy-test.elf` 是根据上面的源文件魔改过得，发送的是伪随机数，数据不会包含直流分量！这样频谱上看起来是正常的。

但是源码被我删了。。。

加油！

## Usage
`dma-proxy-test.elf` 的用法。
```
./dma-proxy-test.elf 10000 128 0
```

**注意：第二个参数测试数据大小不能超过128，此数定义在.h中**

## 魔改思路

1. 只进行发射而不进行接收，原来是收发都测
2. valid参数为0时（最后一个参数），是不会更改发送buffer内容的，这是在valid=0时添加修改buffer内容，按照伪随机码写入buffer。
3. 伪随机数要注意读写的大小端！

> 参考内容：  
> [Linux DMA From User Space 2.0 User app 软件解析](https://github.com/ArtisticZhao/Lilac_UxB/wiki/Linux-DMA-From-User-Space-2.0-User-app-%E8%BD%AF%E4%BB%B6%E8%A7%A3%E6%9E%90) 希望能帮助到你。
