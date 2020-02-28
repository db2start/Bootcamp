## 批量绑定多台服务器的多张网卡

> 说明：
>
> 1、绑定设备为华为的Taishan 200 5280，网卡绑定规划详见图；
>
> 2、至于绑定规则是按照业务需求设定的，比如是否设置网关,部分不变动的直接写在配置文件里面，变动的借助动态传参；
>
> 3、hosts文件里面，对于大量的参数编辑，可以借助UE、EditPlus强大的编辑功能；
>
> 4、文件说明：bond.sh为执行脚本，bondrecovery.sh执行错误之后可进行恢复，hosts是ansible执行的主机名存放文件

步骤：

1).单台测试帮绑定地址

```
sh /tmp/bond.sh 10.178.135.1	10.179.129.1	10.179.129.254	10.179.138.1
```

2).批量绑定多台服务器，借助ansible，hosts详见文件

```
ansible bond -m copy -a "src=/tmp/bond1.sh dest=/tmp/ mode=777" -i hosts  #上传执行文件到每一台服务器

ansible bond -m shell -a "sh /tmp/bond1.sh {{ ip0 }} {{ ip1 }} {{ gw1 }} {{ ip2 }}" -i hosts #执行批量绑定

ansible bond -m file -a "path=/tmp/bond1.sh state=absent" -i hosts  #删除执行文件
```

