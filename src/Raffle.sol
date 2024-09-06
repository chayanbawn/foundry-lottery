// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

/**
 * @title A Simple Raffle Contract
 * @author Chayan Bawn
 * @notice This contract is for creating a simple raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    /* Errors */
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    /* @dev The Duration of the lottery in seconds */
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /* Events */

    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // Gas inefficient
        // require(msg.value >= i_entranceFee, "Send More To Enter Raffle");

        // require solidty verion >= 0.8.26
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle());

        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }

        s_players.push(payable(msg.sender));

        // Events makes migration easier and frontend indexing easier.
        emit RaffleEntered(msg.sender);
    }

    // 1. Get a random number
    // 2. Use random number to pick a player
    // 3. Be automatically call
    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
    }

    /**
     * Getter Functions
     */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
