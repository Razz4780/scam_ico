// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ScamToken} from "src/ScamToken.sol";
import {ScamICO} from "src/ScamICO.sol";
import {ScamICOFundScript, ScamICOClaimRewardScript, ScamICOClaimFundsScript} from "script/ScamICOInteractions.s.sol";

contract SCMICOInteractionsTest is Test {
    ScamICO internal ico;

    function setUp() public {
        ScamToken fundsToken = new ScamToken(20);
        ScamToken rewardsToken = new ScamToken(20);
        ico = new ScamICO(fundsToken, rewardsToken, 20, 120);
        rewardsToken.transfer(address(ico), 20);

        vm.setEnv("ICO_ADDRESS", vm.toString(address(ico)));
    }

    function testFund() public {
        vm.setEnv("FUND_AMOUNT", "20");

        ScamICOFundScript script = new ScamICOFundScript();
        script.setUp();
        script.run();

        assertEq(ico.funds(address(this)), 20);
    }

    function testClaimReward() public {
        vm.setEnv("CLAIM_REWARD_AMOUNT", "20");

        ico.fundsToken().approve(address(ico), 20);
        ico.fund(20);
        skip(120);

        ScamICOClaimRewardScript script = new ScamICOClaimRewardScript();
        script.setUp();
        script.run();

        assertEq(ico.rewardsToken().balanceOf(address(this)), 20);
    }

    function testClaimFunds() public {
        vm.setEnv("CLAIM_FUNDS_AMOUNT", "20");

        ico.fundsToken().approve(address(ico), 20);
        ico.fund(20);
        skip(120);

        ScamICOClaimFundsScript script = new ScamICOClaimFundsScript();
        script.setUp();
        script.run();

        assertEq(ico.fundsToken().balanceOf(address(this)), 20);
    }
}
