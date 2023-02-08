// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

using SafeERC20 for IERC20;

contract ScamICO {
    // Owner of this ICO.
    address public immutable owner;

    // Amount of rewards tokens users get for each funds token given.
    uint256 public immutable ratio;

    // Users can fund this ICO with this token.
    IERC20 public immutable fundsToken;
    // Users get rewarded from this ICO with this token.
    IERC20 public immutable rewardsToken;

    // This ICO needs this much of funding to end.
    uint256 public missing;
    // Records of users' funding.
    mapping(address => uint256) public funds;

    // Users can claim their rewards when this many seconds has passed since this ICO's end.
    uint256 public immutable claimableDelay;
    // Users can claim their rewards from this point in time (seconds since unix epoch).
    // This is set when this ICO ends.
    uint256 public claimableFrom;

    constructor(IERC20 _fundsToken, IERC20 _rewardsToken, uint256 target, uint256 _claimableDelay, uint256 _ratio) {
        owner = msg.sender;
        fundsToken = _fundsToken;
        rewardsToken = _rewardsToken;
        missing = target;
        claimableDelay = _claimableDelay;
        ratio = _ratio;
    }

    // User can fund this ICO using this function.
    function fund(uint256 amount) external {
        if (missing == 0) {
            return;
        }

        if (amount >= missing) {
            amount = missing;
        }

        fundsToken.safeTransferFrom(msg.sender, address(this), amount);
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
    function claimReward() external OnlyWhenClaimable {
        uint256 amount = funds[msg.sender];
        delete(funds[msg.sender]);
        rewardsToken.safeTransfer(msg.sender, amount * ratio);
    }

    // The owner can claim funds with this function.
    function claimFunds() external OnlyWhenClaimable {
        require(msg.sender == owner);

        uint256 amount = fundsToken.balanceOf(address(this));
        fundsToken.safeTransfer(msg.sender, amount);
    }
}
