// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract ScamToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Scam", "SCM", 18) {
        _mint(msg.sender, initialSupply);
    }
}
