// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ScamToken} from "src/ScamToken.sol";
import {ScamICO} from "src/ScamICO.sol";

contract ScamICOTest is Test {
    ScamToken internal rewardsToken;
    ScamToken internal fundsToken;
    ScamICO internal ico;

    function setUp() public {
        rewardsToken = new ScamToken(15);
        fundsToken = new ScamToken(20);
        ico = new ScamICO(fundsToken, rewardsToken, 15, 100);
        rewardsToken.transfer(address(ico), 15);
    }

    function testOneShot() public {
        address user = makeAddr("user");
        fundsToken.transfer(user, 20);

        vm.startPrank(user);
        fundsToken.approve(address(ico), 15);
        ico.fund(15);
        vm.stopPrank();

        assertEq(fundsToken.balanceOf(user), 5);
        assertEq(fundsToken.balanceOf(address(ico)), 15);
        assertEq(ico.missing(), 0);
        assertEq(ico.funds(user), 15);

        skip(100);

        vm.prank(user);
        ico.claimReward();

        assertEq(rewardsToken.balanceOf(user), 15);
        assertEq(rewardsToken.balanceOf(address(ico)), 0);

        ico.claimFunds();

        assertEq(fundsToken.balanceOf(address(this)), 15);
        assertEq(fundsToken.balanceOf(address(ico)), 0);
    }

    function testTwoShots() public {
        address user1 = makeAddr("user1");
        fundsToken.transfer(user1, 10);
        address user2 = makeAddr("user2");
        fundsToken.transfer(user2, 10);

        vm.startPrank(user1);
        fundsToken.approve(address(ico), 10);
        ico.fund(10);
        changePrank(user2);
        fundsToken.approve(address(ico), 10);
        ico.fund(10);
        vm.stopPrank();

        assertEq(fundsToken.balanceOf(user1), 0);
        assertEq(fundsToken.balanceOf(user2), 5);
        assertEq(fundsToken.balanceOf(address(ico)), 15);
        assertEq(ico.missing(), 0);
        assertEq(ico.funds(user1), 10);
        assertEq(ico.funds(user2), 5);

        skip(100);

        vm.prank(user1);
        ico.claimReward();
        vm.prank(user2);
        ico.claimReward();

        assertEq(rewardsToken.balanceOf(user1), 10);
        assertEq(rewardsToken.balanceOf(user2), 5);
        assertEq(rewardsToken.balanceOf(address(ico)), 0);

        ico.claimFunds();

        assertEq(fundsToken.balanceOf(address(this)), 15);
        assertEq(fundsToken.balanceOf(address(ico)), 0);
    }

    function testCannotUserClaimFunds() public {
        address user = makeAddr("user");
        fundsToken.transfer(user, 15);

        vm.startPrank(user);
        fundsToken.approve(address(ico), 15);
        ico.fund(15);
        vm.stopPrank();

        skip(100);

        vm.prank(user);
        vm.expectRevert();
        ico.claimFunds();
    }

    function testCannotClaimToEarly() public {
        address user = makeAddr("user");
        fundsToken.transfer(user, 15);

        vm.expectRevert();
        vm.prank(user);
        ico.claimReward();
        vm.expectRevert();
        ico.claimFunds();

        vm.startPrank(user);
        fundsToken.approve(address(ico), 15);
        ico.fund(15);
        skip(50);
        vm.expectRevert();
        ico.claimReward();
        vm.stopPrank();
        vm.expectRevert();
        ico.claimFunds();

        skip(50);

        vm.prank(user);
        ico.claimReward();
        ico.claimFunds();
    }

    function testCannotFundAfterEnd() public {
        address user = makeAddr("user");
        fundsToken.transfer(user, 20);

        vm.startPrank(user);
        fundsToken.approve(address(ico), 15);
        ico.fund(15);
        vm.expectRevert();
        ico.fund(5);
    }
}
