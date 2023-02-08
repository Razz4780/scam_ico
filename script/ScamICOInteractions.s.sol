// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamICO} from "src/ScamICO.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

abstract contract ScamICOInteractionScript is Script {
    ScamICO internal ico;

    function setUp() public {
        ico = ScamICO(vm.envAddress("ICO_ADDRESS"));
    }
}

contract ScamICOFundScript is ScamICOInteractionScript {
    function run() public {
        uint256 amount = vm.envUint("FUND_AMOUNT");
        ERC20 fundsToken = ico.fundsToken();

        vm.startBroadcast(msg.sender);
        fundsToken.approve(address(ico), amount);
        ico.fund(amount);
        vm.stopBroadcast();
    }
}

contract ScamICOClaimRewardScript is ScamICOInteractionScript {
    function run() public {
        uint256 amount = vm.envUint("CLAIM_REWARD_AMOUNT");

        vm.broadcast(msg.sender);
        ico.claimReward(amount);
    }
}

contract ScamICOClaimFundsScript is ScamICOInteractionScript {
    function run() public {
        uint256 amount = vm.envUint("CLAIM_FUNDS_AMOUNT");

        vm.broadcast(msg.sender);
        ico.claimFunds(amount);
    }
}
