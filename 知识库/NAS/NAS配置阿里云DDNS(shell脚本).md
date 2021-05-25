## 1.前言
----------
由于服务器的外网是动态拨号，每次获取的外网IP都不同,使用高效的Shell脚本，定期通过互联网服务获取当前机器所在网络的外部IP地址，并将新的IP地址通过阿里云提供的API，更新到对应的域名解析记录。
## 2.申请AccessKey
----------
登陆[阿里云官网](https://account.aliyun.com/)，在控制台的右上角，将鼠标移动到头像上，会出现如下列表：
![80954657.png](NAS配置阿里云DDNS(shell脚本)_files/80954657.png)
选择AccessKey管理，会弹出如下提示：
![81038190.png](NAS配置阿里云DDNS(shell脚本)_files/81038190.png)
&emsp;&emsp;选择<font color=red>**开始使用子用户AccessKey**</font>，这里不选择<font color=red>**继续使用AccessKey**</font>，原因是当前进入的页面是主账号，拥有所有的权限，建议通过使用子账户来配置，控制权限。
![81338403.png](NAS配置阿里云DDNS(shell脚本)_files/81338403.png)
填写要创建的登陆名称和显示名称，这里可以按照需要进行填写，然后点击**确定**完成创建用户。如果弹出要验证短信，则按提示完成即可。
![81423132.png](NAS配置阿里云DDNS(shell脚本)_files/81423132.png)
创建完成后，默认账户没有 <font color=red>**AccessKey ID**</font> 和 <font color=red>**AccessKey Secret**</font>。选择左侧用户列表，点击新创建的用户名，出现如下设置：
![81987900.png](NAS配置阿里云DDNS(shell脚本)_files/81987900.png)
选择创建 <font color=red>**AccessKey**</font>
![82078109.png](NAS配置阿里云DDNS(shell脚本)_files/82078109.png)
保存创建好的<font color=red>**AccessKey ID**</font> 和<font color=red>**AccessKey Secret**</font> ，注意<font color=red>**AccessKey Secret**</font> 只会在这一次显示，后续无法在此查看。如果忘记了，只能删除掉重新添加新的。
## 3. 创建用户组
----------
点击用户组，选择<font color=red>**创建用户组**</font>，并填写用户组的相关信息。
![82318620.png](NAS配置阿里云DDNS(shell脚本)_files/82318620.png)
点击<font color=red>**确定**</font>，创建用户组。
## 4. 用户组添加成员
----------
点击<font color=red>**添加组成员**</font>进行添加成员操作
![82414924.png](NAS配置阿里云DDNS(shell脚本)_files/82414924.png)
按如下两步进行操作,然后点击<font color=red>**确认**</font>
![82527384.png](NAS配置阿里云DDNS(shell脚本)_files/82527384.png)
## 5. 用户组添加权限
----------
在用户组后面选择<font color=red>**添加权限**</font>
![5f6d2fb8-e5a6-4c8b-abd2-9c0a36e14d35.png](NAS配置阿里云DDNS(shell脚本)_files/5f6d2fb8-e5a6-4c8b-abd2-9c0a36e14d35.png)
按如图所示步骤进行操作
![82886386.png](NAS配置阿里云DDNS(shell脚本)_files/82886386.png)
到这里，子账户的创建及权限配置就已经完成了。
## 6. 编写aliddns.sh脚本进行DDNS解析
----------
具体脚本代码如下:
[![f4852bd8-9050-41f5-90bb-276494e59c56.png](NAS配置阿里云DDNS(shell脚本)_files/f4852bd8-9050-41f5-90bb-276494e59c56.png)](wiz://open_attachment?guid=09a81cc9-7b00-4f83-b08b-f7c81e44633b)

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
    AliDDNS_DomainName=""
    # 设置需要DDNS的子域名 <SubDomainName>
    AliDDNS_SubDomainName=""
    
    # 设置域名记录的TTL (生存周期)
    # 免费版产品最低为600(10分钟)~86400(1天), 付费版(企业版)包括以上范围, 还可以按照购买产品配置设置为：
    # 600(10分钟)、120(2分钟)、60(1分钟)、10(10秒)、5(5秒)、1(1秒), 
    # 请按照自己的产品配置和DDNS解析速度需求妥善配置TTL值, 免费版设置低于600的TTL将会报错。
    AliDDNS_TTL="600"
    
    # 设置阿里云的AccessKeyId/AccessKeySecret,
    
    # 设置阿里云的Access Key
    AliDDNS_AK=""
    # 设置阿里云的Secret Key
    AliDDNS_SK=""
    
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




## 7. 添加开机启动命令实现开机自动运行脚本
----------
将编辑好的脚本文件上传到群辉中,并登录ssh客户端`sudo -i`切换至`root`用户将上传的脚本文件拷贝到`/etc`目录下后,对`rc`文件末尾追加如下命令:
![83864482.png](NAS配置阿里云DDNS(shell脚本)_files/83864482.png)
对应运行日志会输出到`/volume1/homes/pacher/aliddns.log ` 这个文件中,如果有需要可以自行修改.







