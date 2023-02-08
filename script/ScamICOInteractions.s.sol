// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ScamICO} from "src/ScamICO.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

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
