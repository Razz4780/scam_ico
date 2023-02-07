// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ScamToken} from "../src/ScamToken.sol";

contract ScamTokenTest is Test {
    ScamToken public token;

    function setUp() public {
        token = new ScamToken(20);
    }

    function testDeploy() public {
        assertEq(token.totalSupply(), 20);
        assertEq(token.balanceOf(address(this)), 20);
    }

    function testTransfer() public {
        token.transfer(msg.sender, 10);
        assertEq(token.balanceOf(msg.sender), 10);
        assertEq(token.balanceOf(address(this)), 10);
    }
}
