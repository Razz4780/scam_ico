// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract ScamICO {
    // Owner of this ICO.
    address public immutable owner;

    // Users can fund this ICO with this token.
    ERC20 public immutable fundsToken;
    // Users get rewarded from this ICO with this token.
    ERC20 public immutable rewardsToken;

    // This ICO needs this much of funding to end.
    uint256 public missing;
    // Records of users' funding.
    mapping(address => uint256) public funds;

    // Users can claim their rewards when this many seconds has passed since this ICO's end.
    uint256 public immutable claimableDelay;
    // Users can claim their rewards from this point in time (seconds since unix epoch).
    // This is set when this ICO ends.
    uint256 public claimableFrom;

    constructor(ERC20 _fundsToken, ERC20 _rewardsToken, uint256 target, uint256 _claimableDelay) {
        owner = msg.sender;
        fundsToken = _fundsToken;
        rewardsToken = _rewardsToken;
        missing = target;
        claimableDelay = _claimableDelay;
    }

    // User can fund this ICO using this function.
    function fund(uint256 amount) external {
        require(missing > 0);

        if (amount >= missing) {
            amount = missing;
        }

        fundsToken.transferFrom(msg.sender, address(this), amount);
        funds[msg.sender] += amount;
        missing -= amount;

        if (missing == 0) {
            claimableFrom = block.timestamp + claimableDelay;
        }
    }

    // This modifier passes only when the ICO has ended and tokens are claimable.
    modifier WhenClaimable() {
        require(missing == 0);
        require(claimableFrom <= block.timestamp);
        _;
    }

    // User can claim their reward with this function.
    function claimReward() external WhenClaimable {
        uint256 reward = funds[msg.sender];
        rewardsToken.transfer(msg.sender, reward);
    }

    // The owner can claim funds with this function.
    function claimFunds() external WhenClaimable {
        require(msg.sender == owner);

        uint256 balance = fundsToken.balanceOf(address(this));
        fundsToken.transfer(msg.sender, balance);
    }
}
