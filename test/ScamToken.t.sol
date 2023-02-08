// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ScamToken} from "src/ScamToken.sol";

contract ScamTokenTest is Test {
    ScamToken internal token;

    function setUp() public {
        token = new ScamToken(20);
    }

    function testDeploy() public {
        assertEq(token.totalSupply(), 20);
        assertEq(token.balanceOf(address(this)), 20);
    }

    function testTransfer() public {
        address user = makeAddr("user");
        token.transfer(user, 10);

        assertEq(token.balanceOf(user), 10);
        assertEq(token.balanceOf(address(this)), 10);
    }
}
