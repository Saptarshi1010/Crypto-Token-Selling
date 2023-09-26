// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Token {
    string public name = "Token";
    string public symbol = "CT";
    // string public standard = "@CT";
    uint public totalSupply;
    uint public userid;

    address public owner;

    //users who takes out thetokens
    address[] public holderToken;
    struct TokenHolder {
        uint tokenid;
        uint totaltoken;
        address from;
        address to;
        bool tokenholding;
    }

    mapping(address => TokenHolder) public tokenholderinfos;
    mapping(address => uint) public balanceof;

    //here one address is allowing other address to spend the token
    mapping(address => mapping(address => uint)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint _value);

    // _value is for how much amount thet can spend on behalf of the user
    event Approval(
        address indexed _from,
        address indexed _spender,
        uint _value
    );

    constructor(uint _initialsupply) {
        owner = msg.sender;
        balanceof[msg.sender] = _initialsupply;
        totalSupply = _initialsupply;
    }

    function increment() internal {
        userid++;
    }

    //transfer the tokens personaly
    function transfer(address _to, uint _value) public returns (bool success) {
        require(balanceof[msg.sender] >= _value, "not addequate fund");
        increment();
        balanceof[msg.sender] -= _value;
        balanceof[_to] += _value;

        TokenHolder storage particulartokenholder = tokenholderinfos[_to];
        particulartokenholder.tokenid = userid;
        particulartokenholder.totaltoken = _value;
        particulartokenholder.from = msg.sender;
        particulartokenholder.to = _to;
        particulartokenholder.tokenholding = true;

        holderToken.push(_to);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // sending the tokens on behalf of someone
    function transferFrom(
        address _from,
        address _to,
        uint _value
    ) public returns (bool success) {
        require(balanceof[_from] >= _value, "amount not apppropriate");
        require(
            allowance[_from][msg.sender] >= _value,
            "allowance limit not met"
        );

        balanceof[_from] -= _value;
        balanceof[_to] -= _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function gettokenholderData(
        address _address
    ) public view returns (uint, uint, address, address, bool) {
        return (
            tokenholderinfos[_address].tokenid,
            tokenholderinfos[_address].totaltoken,
            tokenholderinfos[_address].from,
            tokenholderinfos[_address].to,
            tokenholderinfos[_address].tokenholding
        );
    }

    function gettokenHolder() public view returns (address[] memory) {
        return holderToken;
    }
}
