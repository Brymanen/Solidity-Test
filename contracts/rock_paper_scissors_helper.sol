// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./rock_paper_scissors.sol";

contract RockPaperScissorsHelper is RockPaperScissors {
    function getGamesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerGamesCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < games.length; i++) {
        if (gameToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
        }
    }
    return result;
    }
}