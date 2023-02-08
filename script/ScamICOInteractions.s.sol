// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamICO} from "src/ScamICO.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "forge-std/console.sol";

using SafeERC20 for IERC20;

abstract contract ScamICOInteractionScript is Script {
    ScamICO internal ico;

    function setUp() public {
        ico = ScamICO(vm.envAddress("ICO_ADDRESS"));
    }
}

contract ScamICOFundScript is ScamICOInteractionScript {
    function run() public {
        uint256 amount = vm.envUint("FUND_AMOUNT");
        IERC20 fundsToken = ico.fundsToken();

        vm.startBroadcast(msg.sender);
        fundsToken.safeApprove(address(ico), amount);
        ico.fund(amount);
        vm.stopBroadcast();
    }
}

contract ScamICOClaimRewardScript is ScamICOInteractionScript {
    function run() public {
        vm.broadcast(msg.sender);
        ico.claimReward();
    }
}

contract ScamICOClaimFundsScript is ScamICOInteractionScript {
    function run() public {
        vm.broadcast(msg.sender);
        ico.claimFunds();
    }
}

contract ScamICOAddRewardsScript is ScamICOInteractionScript {
    function run() public {
        uint256 target = vm.envUint("TARGET");
        uint256 ratio = vm.envUint("RATIO");

        IERC20 rewardsToken = ico.rewardsToken();

        vm.broadcast(msg.sender);
        rewardsToken.transfer(address(ico), target * ratio);
    }
}

contract ScamICOReadStateScript is ScamICOInteractionScript {
    function run() public view {
        console.log("Funds token: %s", address(ico.fundsToken()));
        console.log("Rewards token: %s", address(ico.rewardsToken()));
        console.log("Rewards available: %s", ico.rewardsToken().balanceOf(address(ico)));
        console.log("Ratio: %s", ico.ratio());

        uint256 missing = ico.missing();
        console.log("Missing: %s", ico.missing());

        if (missing == 0) {
            uint256 claimableFrom = ico.claimableFrom();
            if (claimableFrom <= block.timestamp) {
                console.log("Funds and rewards are now claimable!");
            } else {
                console.log("Funds and rewards will be claimable at %s", claimableFrom);
            }
        } else {
            console.log("Funds and rewards are not claimable yet");
        }
    }
}
