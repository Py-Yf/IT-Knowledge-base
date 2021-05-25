
# ERC20合约详解```solidity
pragma solidity ^0.4.16;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
contract TokenERC20 {
    // 公共变量
    string public name;     //发行币名称
    string public symbol;    //发行币简写标志
    uint8 public decimals = 18;

    // 18位小数是强烈建议的默认值，尽量避免更改
    uint256 public totalSupply; //发行币总量

    // 这将创建一个包含所有余额的数组
    mapping (address => uint256) public balanceOf;     

    //每个人对所有人的授权准信额度
    mapping (address => mapping (address => uint256)) public allowance;    

    // 这会在区块链上生成一个公共事件来通知客户端
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 这会在区块链上生成一个公共事件来通知客户端 --授权事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
 
    // 这将通知客户销毁代币的数量
    event Burn(address indexed from, uint256 value);

    /**
    * Constructor function  构造函数
    * 用初始供应令牌初始化合约给合约的创建者
    */
    function TokenERC20( 
        uint256 initialSupply, 
        string tokenName, 
        string tokenSymbol 
    ) public {
        //以十进制金额更新总供应量
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;     // 给创造者所有初始代币
        name = tokenName;     // 设置代币名称
        symbol = tokenSymbol;     // 设置代币名称简写
    }

    /**
    * 内部转让，只能按本合同调用
    */
    function _transfer(address _from, address _to, uint _value) internal { 
        // 防止转账到0x0地址。使用销毁()
        require(_to != 0x0);
        // 检查发件人是否有足够的代币
        require(balanceOf[_from] >= _value);
        // 检查代币是否溢出
        require(balanceOf[_to] + _value >= balanceOf[_to]); 
        // 将其保存为将来的断言
        uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
        // 从发送者中减去
        balanceOf[_from] -= _value;
        // 将相同的代币添加到收件人
        balanceOf[_to] += _value;
        // 调用事件
        emit Transfer(_from, _to, _value);
        // 断言用于使用静态分析来查找代码中的错误。他们永远不应该失败
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
    * Transfer tokens  转账
    * 从你的账户发送 `_value` 代币 给 `_to` 
    * @param _to 收信人的地址
    * @param _value 发送代币金额
    */
    function transfer(address _to, uint256 _value) public returns (bool success) { 
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * 从其他地址转移代币
    * 代表' _from '将' _value '标记发送给' _to '
    * @param _from 发送者地址
    * @param _to 接收者地址
    * @param _value 发送代币数量
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // 查看授权额度是否满足要求
        allowance[_from][msg.sender] -= _value;    / / 扣除授权账户中金额
        _transfer(_from, _to, _value);    / / 扣除委托账户中金额
        return true;
    }

    /**
    * 为其他授权账户地址设置代币数量
    * 允许' _spender '代表你花费不超过' _value '代币
    * @param _spender 授权使用的地址
    * @param _value  能花的最大金额
    */
    function approve(address _spender, uint256 _value) public returns (bool success) { 
        allowance[msg.sender][_spender] = _value;      // 为其他授权账户地址设置代币数量
        emit Approval(msg.sender, _spender, _value);     // 发布事件
        return true; 
    }

    /**
    * 在其他授权账户地址分配代币并通知
    * 允许' _spender '代表你花费不超过' _value '的代币，然后ping关于它的合约
    * @param _spender 授权使用的地址
    * @param _value 他们能花的最大金额
    * @param _extraData 一些需要发送到已批准的合同的额外信息
    */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true; 
        }
    }

    /**
    * 销毁代币 
    * 不可逆地从合约中移除' _value '代币
    * @param _value 需要销毁的代币数量
    */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);    // 检查发送者是否有足够的代币
        balanceOf[msg.sender] -= _value;     // 从发送者中减去
        totalSupply -= _value;    // 更新totalSupply
        emit Burn(msg.sender, _value);     //发送事件
        return true; 
    }

    /**
    * 销毁其他账户的代币
    * 代表' _from '从合约中不可逆地移除' _value '代币
    * @param _from 发送人的地址
    * @param _value 需要销毁的代币数量
    */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);     // 检查目标余额是否足够
        require(_value <= allowance[_from][msg.sender]);     // 查看授权额度是否满足要求
        balanceOf[_from] -= _value;     // 从目标余额中减去
        allowance[_from][msg.sender] -= _value;     // 扣除授权账户中金额
        totalSupply -= _value;    // 更新totalSupply
        emit Burn(_from, _value);    //发送事件
        return true;
    }
}
```

