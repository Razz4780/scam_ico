// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployScamTokenScript} from "script/DeployScamToken.s.sol";
import {DeployScamICOScript} from "script/DeployScamICO.s.sol";
import {ScamToken} from "src/ScamToken.sol";
import {ScamICO} from "src/ScamICO.sol";

contract DeployScamICOTest is Test {
    function testDeploy() public {
        ScamToken fundsToken = new ScamToken(20);
        vm.setEnv("FUNDS_TOKEN", vm.toString(address(fundsToken)));
        ScamToken rewardsToken = new ScamToken(20);
        vm.setEnv("REWARDS_TOKEN", vm.toString(address(rewardsToken)));
        vm.setEnv("TARGET", "20");
        vm.setEnv("CLAIMABLE_DELAY", "120");

        DeployScamICOScript script = new DeployScamICOScript();
        ScamICO ico = script.run();

        assertEq(ico.owner(), address(this));
        assertEq(ico.missing(), 20);
        assertEq(ico.claimableDelay(), 120);
        assertEq(address(ico.fundsToken()), address(fundsToken));
        assertEq(address(ico.rewardsToken()), address(rewardsToken));
    }
}
