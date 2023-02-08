# Contracts

## ScamICO

This is a Solidity playground project. The contract is a simple ICO contract. Users can participate in the ICO through transferring a specified ERC20 tokens to the contract. Once the target amount is raised, the sale is over. After specified time has passed, users can claim their rewards (in other specified ERC20 token).

## ScamToken

A thin wrapper over ERC20. Once created, mints the total supply for the creator.

# Scripts

All scripts are configured through the `.env` file.

## DeployScamICO:DeployScamICOScript
Deploys the ScamICO contract. Configuration:
1. `FUNDS_TOKEN` - address of the ERC20 token in which funding is raised.
2. `REWARDS_TOKEN` - address of the ERC20 token in which rewards are payed.
3. `TARGET` - target amount of funding.
4. `CLAIMABLE_DELAY` - required number of seconds between ICO end and claiming.
5. `RATIO` - amount of rewards tokens each user will get for each funding token given.

## DeployScamToken:DeployScamTokenScript
Deploys the ScamToken contract. Configuration:
1. `TOTAL_SUPPLY` - total supply of the token.

## ScamICOInteractions:ScamICOFundScript
Transfers funds to the ScamICO contract. Configuration:
1. `ICO_ADDRESS` - address of the ICO contract.
2. `FUND_AMOUNT` - amount of tokens to transfer.

## ScamICOInteractions:ScamICOClaimRewardScript
Claims reward from the ScamICO contract. Configuration:
1. `ICO_ADDRESS` - address of the ICO contract.

## ScamICOInteractions:ScamICOClaimFundsScript
Claims funds from the ScamICO contract. This can be done only by the ICO creator. Configuration:
1. `ICO_ADDRESS` - address of the ICO contract.

## ScamICOInteractions:ScamICOReadStateScript
Prints current state of the ScamICO contract. Configuration:
1. `ICO_ADDRESS` - address of the ICO contract.

## ScamICOInteractions:ScamICOAddRewardsScript
Transfers rewards to the ScamICO contract. Configuration:
1. `ICO_ADDRESS` - address of the ICO contract.
2. `TARGET` - target amount of funding.
3. `RATIO` - amount of rewards tokens each user will get for each funding token given.
