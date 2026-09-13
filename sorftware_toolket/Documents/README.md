# powershell 添加命令别名和Tab补全

## 使用方法
（1）查配置文件位置
打开powershell
```
#
PS C:\Users\LSHM> $PROFILE
C:\Users\LSHM\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

```
将WindowsPowerShell目录下的文件内容拷贝到上述配置文件，没有则自己创建

（2）添加权限
以管理员身份打开 PowerShell，然后执行：
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

```

（3）source包含或重启powershell

```
. $PROFILE
```

