// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamToken} from "src/ScamToken.sol";

contract DeployScamTokenScript is Script {
    function run(uint256 totalSupply) public returns (ScamToken) {
        uint256 deployerPrivateKey = vm.envUint("TEST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ScamToken token = new ScamToken(totalSupply);

        vm.stopBroadcast();

        return token;
    }
}
