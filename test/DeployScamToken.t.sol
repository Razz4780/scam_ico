// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployScamTokenScript} from "script/DeployScamToken.s.sol";
import {ScamToken} from "src/ScamToken.sol";

contract ScamICOTest is Test {
    function testDeploy() public {
        DeployScamTokenScript script = new DeployScamTokenScript();
        ScamToken token = script.run(20);
        assertEq(token.totalSupply(), 20);

        address deployerAddress = vm.envAddress("TEST_ADDRESS");
        assertEq(token.balanceOf(deployerAddress), 20);
    }
}
