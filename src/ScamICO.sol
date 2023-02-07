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
        if (missing == 0) {
            return;
        }

        if (amount >= missing) {
            amount = missing;
        }

        fundsToken.transferFrom(msg.sender, address(this), amount);
        unchecked {
            // ERC20 transfer passed.
            funds[msg.sender] += amount;
            // Amount was adjusted above.
            missing -= amount;
        }

        if (missing == 0) {
            claimableFrom = block.timestamp + claimableDelay;
        }
    }

    // This modifier passes only when the ICO has ended and tokens are claimable.
    modifier OnlyWhenClaimable() {
        require(missing == 0);
        require(claimableFrom <= block.timestamp);
        _;
    }

    // User can claim their reward with this function.
    function claimReward(uint256 amount) external OnlyWhenClaimable {
        funds[msg.sender] -= amount;
        rewardsToken.transfer(msg.sender, amount);
    }

    // The owner can claim funds with this function.
    function claimFunds(uint256 amount) external OnlyWhenClaimable {
        require(msg.sender == owner);

        fundsToken.transfer(msg.sender, amount);
    }
}
