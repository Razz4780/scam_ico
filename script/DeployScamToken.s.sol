// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamToken} from "src/ScamToken.sol";

contract DeployScamTokenScript is Script {
    function run() public returns (ScamToken) {
        uint256 totalSupply = vm.envUint("TOTAL_SUPPLY");

        vm.broadcast(msg.sender);
        ScamToken token = new ScamToken(totalSupply);

        return token;
    }
}
