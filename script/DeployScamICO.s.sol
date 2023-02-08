// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamICO} from "src/ScamICO.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DeployScamICOScript is Script {
    function run() public returns (ScamICO) {
        IERC20 fundsToken = IERC20(vm.envAddress("FUNDS_TOKEN"));
        IERC20 rewardsToken = IERC20(vm.envAddress("REWARDS_TOKEN"));
        uint256 target = vm.envUint("TARGET");
        uint256 claimableDelay = vm.envUint("CLAIMABLE_DELAY");
        uint256 ratio = vm.envUint("RATIO");

        vm.broadcast(msg.sender);
        ScamICO ico = new ScamICO(fundsToken, rewardsToken, target, claimableDelay, ratio);

        return ico;
    }
}
