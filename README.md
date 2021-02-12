## 说明

这个 docker 的作用：

在docker里运行一个 (openfortinet)[https://github.com/adrienverge/openfortivpn]，然后使用 (microsocks)[https://github.com/rofl0r/microsocks]
提供一个 socks5 服务。

制作这个docker最原始的目的是为了在 clash 里分流查论文的流量）

## build

参考：
```
docker build -t fortinet-socks5 .
```

## 使用

```
docker run -p 1080:1080 --cap-add=ALL -d -v /home/my/config:/etc/openfortivpn/config fortinet-socks5 -p 1080
```

参数说明：

- ```-p 1080:1080``` docker内的socks5服务默认是在 1080 端口的，这里是把它映射到本地
- ```--cap-add=ALL``` 如果要操作 /dev/ppp 需要一些权限，暂时懒得二分了……
- ```-d``` daemon模式
- ```-v``` 把自己的vpn配置文件文件替换掉docker中 /etc/openfortivpn/config 即可
- ```fortinet-socks5``` build 时候写的名字
- ```-p 1080``` 传给里面的 socks5 服务的参数，参考：https://github.com/rofl0r/microsocks#command-line-options
- docker-compose 不会，以后再说）