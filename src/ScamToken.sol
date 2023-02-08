// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ScamToken is ERC20 {
    constructor(uint256 totalSupply) ERC20("Scam", "SCM") {
        _mint(msg.sender, totalSupply);
    }
}
