// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamToken} from "../src/ScamToken.sol";

contract DeployScamTokenScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new ScamToken(100000e18);

        vm.stopBroadcast();
    }
}
