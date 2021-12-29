pragma solidity ^0.8.10;

library SafeMath{
    function add(uint a, uint b) internal pure returns(uint){
        uint result = a + b;

        require(result >= a, "Sum overflow!");

        return result;
    }

    function sub(uint a, uint b) internal pure returns(uint){
        uint result = a - b;

        require(result <= a, "Subtract underflow!");

        return result;
    }

    function mul(uint a, uint b) internal pure returns(uint){
        if(a == 0 || b == 0){
            return 0;
        }

        uint result = a * b;

        require(result / a == b, "Multiply overflow!");

        return result;
    }

    function div(uint a, uint b) internal pure returns(uint){
        if(a == 0){
            return 0;
        }

        require(b != 0, "Division by zero!");

        uint result = a / b;

        return result;
    }
}

abstract contract Ownable {
    address payable public owner;

    event OwnershipTransferred(address newOwner);

    constructor() {
        owner = payable(msg.sender);
    }

    modifier ownerOnly(){
        require(payable(msg.sender) == owner, "Not the owner!");
        _;
    }

    function tranferOwnership(address payable newOwner) ownerOnly public {
        owner = newOwner;

        emit OwnershipTransferred(owner);
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

interface BEP20 {

}

contract BasicToken is Ownable, ERC20, BEP20 {
    using SafeMath for uint;

    uint internal _totalSupply;
    mapping(address => uint) internal _balances;
    mapping(address => mapping(address => uint)) internal _allowed;
    
    function totalSupply() public override view returns (uint){
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint balance){
        return _balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining){
        return _allowed[tokenOwner][spender];
    }

    function transfer(address to, uint tokens) public override returns (bool success){
        require(_balances[msg.sender] >= tokens);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint tokens) public override returns (bool success){
        _allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(_allowed[from][msg.sender] >= tokens);
        require(_balances[from] >= tokens);
        require(to != address(0));

        _balances[from] = _balances[from].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

        emit Transfer(from, to, tokens);

        return true;
    }
}

contract MintableToken is BasicToken {
    using SafeMath for uint;

    event Mint(address indexed to, uint tokens);

    function mint(address to, uint tokens) ownerOnly public {
        _balances[to] = _balances[to].add(tokens);
        _totalSupply = _totalSupply.add(tokens);

        emit Mint(to, tokens);
    }
}

contract TCoin is MintableToken {
    string public constant _name = "TCoin";
    string public constant _symbol = "TCN";
    uint8 public constant _decimals = 18;
}