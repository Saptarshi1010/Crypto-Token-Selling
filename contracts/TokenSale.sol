// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Token.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    address admin;
    Token public token;
    uint public tokenprice;
    uint public tokensold;

    event Sell(address _buyer, uint _amount);

    constructor(Token _token, uint _tokenprice) {
        admin == msg.sender;
        token = _token;
        tokenprice = _tokenprice;
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only owner can access this");
        _;
    }

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function buyToken(uint _nooftokens) public payable {
        require(msg.value == multiply(_nooftokens, tokenprice));

        //checking the balance of tokensale contract that it has enough balance to buy the tokens
        require(token.balanceof(address(this)) >= _nooftokens);
        //here we are converting token to wei
        require(token.transfer(msg.sender, _nooftokens * 1000000000000000000));

        tokensold += _nooftokens;

        emit Sell(msg.sender, _nooftokens);
    }

    function endSale() public onlyAdmin {
        require(token.transfer(admin, token.balanceof(address(this))));

        //payback to the admin
        payable(admin).transfer(address(this).balance);
    }
}
