pragma solidity 0.8.7;

library SafeMath{
    uint internal result = 0;

    function add(uint a, uint b) internal pure returns(uint){
        result = a + b;

        require(result >= a, "Sum overflow!");

        return result;
    }

    function sub(uint a, uint b) internal pure returns(uint){
        result = a - b;

        require(result <= a, "Subtract underflow!");

        return result;
    }

    function mul(uint a, uint b) internal pure returns(uint){
        if(a == 0 || b == 0){
            return 0;
        }

        result = a * b;

        require(result / a == b, "Multiply overflow!");

        return result;
    }

    function div(uint a, uint b) internal pure returns(uint){
        if(a == 0){
            return 0;
        }

        require(b != 0, "Division by zero!");

        result = a / b;

        return result;
    }
}

contract Ownable {
    address payable public owner;

    event OwnershipTransferred(address newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier ownerOnly(){
        require(msg.sender == owner, "Not the owner!");
        _;
    }

    function tranferOwnership(address payable newOwner) ownerOnly public {
        owner = newOwner;

        emit OwnershipTransferred(owner);
    }
}

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract TCoin is Ownable {
    using SafeMath for uint;

    string public constant name = "TCoin";
    string public constant symbol = "TCN";
    uint8 public constant decimals = 18;
    uint public constant totalSupply;

    mapping(address => uint) balances;

    event Mint(address indexed to, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    function mint(address to, uint tokens) onlyOwner public {
        balances[to] = balances[to].add(tokens);
        totalSupply = totalSupply.add(tokens);

        emit Mint(to, tokens);
    }


    function transfer(address to, uint tokens) public {
        require(balances[msg.sender] >= tokens);
        require(to != address(0));

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);
    }
}