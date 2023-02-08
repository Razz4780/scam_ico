// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployScamTokenScript} from "script/DeployScamToken.s.sol";
import {ScamToken} from "src/ScamToken.sol";

contract DeployScamTokenTest is Test {
    function testDeploy() public {
        vm.setEnv("TOTAL_SUPPLY", "20");

        DeployScamTokenScript script = new DeployScamTokenScript();
        ScamToken token = script.run();

        assertEq(token.totalSupply(), 20);
        assertEq(token.balanceOf(address(this)), 20);
    }
}
