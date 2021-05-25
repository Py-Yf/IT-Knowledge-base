#配置NAS自定义应用开机启动
## 1. 编写opkg和aliddns启动脚本
### opkg.sh
```shell
#!/bin/sh

# Mount/Start Entware
mkdir -p /opt
mount -o bind "/volume1/@Entware/opt" /opt
/opt/etc/init.d/rc.unslung start

# Add Entware Profile in Global Profile
if grep  -qF  '/opt/etc/profile' /etc/profile; then
    echo "Confirmed: Entware Profile in Global Profile"
else
    echo "Adding: Entware Profile in Global Profile"
cat >> /etc/profile <<"EOF"

# Load Entware Profile
. /opt/etc/profile
. /etc/profile
EOF
fi

# Update Entware List
/opt/bin/opkg update
```
[![3cac7a32-3ac8-4f55-80df-64fb64fa2437.png](配置NAS自定义应用开机启动  _files/3cac7a32-3ac8-4f55-80df-64fb64fa2437.png)](wiz://open_attachment?guid=91463477-f0ba-4f48-9e88-7c2531e67fd4)
### aliddns.sh
```
#!/bin/bash
echo "[$(date "+%G/%m/%d %H:%M:%S")] AliDDNS.sh start..."

function  Check_IP() {
     IP=$1
     VALID_CHECK=$( echo  $IP| awk  -F.  '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}' )
     if  echo  $IP| grep  -E  "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" > /dev/null ;  then
         if  [ ${VALID_CHECK:-no} ==  "yes"  ];  then
             echo  "[$(date "+%G/%m/%d %H:%M:%S")] IP $IP available."
             CheckResult="Pass"
         else
             echo  "[$(date "+%G/%m/%d %H:%M:%S")] IP $IP not available!"
             CheckResult="Reject"
         fi
     else
         echo  "[$(date "+%G/%m/%d %H:%M:%S")] IP format error!"
         CheckResult="Reject"
     fi
}

while true
do

# 设置需要DDNS的地址，格式为 AliDDNS_SubDomainName.AliDDNS_DomainName ,
# 例如 AliDDNS_DomainName 为 example.com, AliDDNS_SubDomainName 为 ddns ,
# 连接起来就是 ddns.example.com
#
# 设置需要DDNS的域名 <DomainName>
AliDDNS_DomainName="pacher.cn"
# 设置需要DDNS的子域名 <SubDomainName>
AliDDNS_SubDomainName="www"

# 设置域名记录的TTL (生存周期)
# 免费版产品最低为600(10分钟)~86400(1天), 付费版(企业版)包括以上范围, 还可以按照购买产品配置设置为：
# 600(10分钟)、120(2分钟)、60(1分钟)、10(10秒)、5(5秒)、1(1秒), 
# 请按照自己的产品配置和DDNS解析速度需求妥善配置TTL值, 免费版设置低于600的TTL将会报错。
AliDDNS_TTL="600"

# 设置阿里云的AccessKeyId/AccessKeySecret,

# 设置阿里云的Access Key
AliDDNS_AK="LTAI4GDZyXwZR7pbZ8rf94cU"
# 设置阿里云的Secret Key
AliDDNS_SK="Uyi1HJqw9DvUPVCWyWz12W5sMNvNCY"

# 设置获取本机IP需要执行的命令 (用于nslookup命令获取DDNS域名的当前IP)
AliDDNS_LocalIP="curl -s whatismyip.akamai.com"
# 设置解析使用的DNS服务器 (推荐使用 223.5.5.5/223.6.6.6 , 毕竟都是阿里家的东西)
AliDDNS_DomainServerIP="223.5.5.5"

# 获取本机公网IP
AliDDNS_LocalIP=`$AliDDNS_LocalIP 2>&1` || die "$AliDDNS_LocalIP"
# 获取DDNS域名当前解析记录IP
AliDDNS_DomainIP=`nslookup $AliDDNS_SubDomainName.$AliDDNS_DomainName $AliDDNS_DomainServerIP 2>&1`

# 判断上一条命令的执行是否成功
if [ "$?" -eq "0" ]
then
    AliDDNS_DomainIP=`echo "$AliDDNS_DomainIP" | grep 'Address:' | tail -n1 | awk '{print $NF}'`
# 检查本机IP是否合规，如果合规则将本机IP与域名获取IP进行对比    
    Check_IP $AliDDNS_LocalIP
    if [ "$CheckResult" = "Pass" ] 
    then
        if [ "$AliDDNS_LocalIP" = "$AliDDNS_DomainIP" ]
        then
            echo "[$(date "+%G/%m/%d %H:%M:%S")] Local IP ($AliDDNS_LocalIP) is the same with Domain IP ($AliDDNS_DomainIP)"
            echo "[$(date "+%G/%m/%d %H:%M:%S")] No change modified ..., AliDDNS.sh will take 5 minute break."
        sleep 300
        continue
        fi
    fi
         
fi

# 如果IP发生变动，开始进行修改
# 生成时间戳
timestamp=`date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ"`
# URL加密函数
urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c
    do
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
    done
    echo -n $out
}
# URL加密命令
enc() {
    echo -n "$1" | urlencode
}
# 发送请求函数
send_request() {
    local args="AccessKeyId=$AliDDNS_AK&Action=$1&Format=json&$2&Version=2015-01-09"
    local hash=$(echo -n "GET&%2F&$(enc "$args")" | openssl dgst -sha1 -hmac "$AliDDNS_SK&" -binary | openssl base64)
    curl -s "http://alidns.aliyuncs.com/?$args&Signature=$(enc "$hash")"
}
# 获取记录值 (RecordID)
get_recordid() {
    grep -Eo '"RecordId":"[0-9]+"' | cut -d':' -f2 | tr -d '"'
}
# 请求记录值 (RecordID)
query_recordid() {
    send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$AliDDNS_SubDomainName.$AliDDNS_DomainName&Timestamp=$timestamp"
}
# 更新记录值 (RecordID)
update_record() {
    send_request "UpdateDomainRecord" "RR=$AliDDNS_SubDomainName&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$AliDDNS_TTL&Timestamp=$timestamp&Type=A&Value=$AliDDNS_LocalIP"
}
# 添加记录值 (RecordID)
add_record() {
    send_request "AddDomainRecord&DomainName=$AliDDNS_DomainName" "RR=$AliDDNS_SubDomainName&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$AliDDNS_TTL&Timestamp=$timestamp&Type=A&Value=$AliDDNS_LocalIP"
}

# 判断RecordIP是否为空
if [ "$AliDDNS_RecordID" = "" ]
then
    AliDDNS_RecordID=`query_recordid | get_recordid`
fi
if [ "$AliDDNS_RecordID" = "" ]
then
    AliDDNS_RecordID=`add_record | get_recordid`
    echo -e "[$(date "+%G/%m/%d %H:%M:%S")] Added RecordID : $AliDDNS_RecordID \n"
else
    update_record $AliDDNS_RecordID
    echo -e "[$(date "+%G/%m/%d %H:%M:%S")] Updated RecordID : $AliDDNS_RecordID \n"
fi

# 输出最终结果
if [ "$AliDDNS_RecordID" = "" ]; then
    # 输出失败结果 (因为没有获取到RecordID)
    echo "[$(date "+%G/%m/%d %H:%M:%S")] DDNS Update Failed !"
else
    # 输出成功结果
    echo "[$(date "+%G/%m/%d %H:%M:%S")] DDNS Update Success, New IP is : $AliDDNS_LocalIP"
fi

sleep 30
done
```
[![94663160-cdeb-40db-8e8f-b0ae383795fa.png](配置NAS自定义应用开机启动  _files/94663160-cdeb-40db-8e8f-b0ae383795fa.png)](wiz://open_attachment?guid=d1c4476d-2f27-4652-8e31-36bbf4e0bd3d)
### opkg安装flood 输出重定向
[![26a0c739-6cc8-4ad5-989d-f8cf56e92007.png](配置NAS自定义应用开机启动  _files/26a0c739-6cc8-4ad5-989d-f8cf56e92007.png)](wiz://open_attachment?guid=44946ef5-1a62-485d-8177-8f02094cebdf)
## 2. 添加NAS自定义应用开机启动
在 `/etc/rc` 文件末尾 `exit 0` 之前追加如下配置
```
# 添加 opkg qbit flood 启动脚本并重定向日志输出
/etc/opkg.sh >> /volume1/homes/pacher/log/opkg.log
# 添加Aliddns启动脚本 并重定向日志输出
/etc/aliddns.sh >> /volume1/homes/pacher/log/aliddns.log
```

