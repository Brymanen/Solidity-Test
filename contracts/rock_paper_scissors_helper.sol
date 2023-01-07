// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./rock_paper_scissors.sol";
import "./safemath.sol";

contract RockPaperScissorsHelper is RockPaperScissors {

    using SafeMath for uint256;

    uint playGameFee = 1 wei;

    function withdraw() external onlyOwner {
        address _owner = owner();
        //_owner.transfer(address(this).balance);
        payable(_owner).transfer(address(this).balance);
    }

    function setPlayGameFee(uint _fee) external onlyOwner {
        playGameFee = _fee;
    }
    
    function getGamesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerGamesCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < games.length; i = i.add(1)) {
            if (gameToOwner[i] == _owner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }
        return result;
    }

    function playRockPaperScissors(string memory playerInput) public payable returns (string memory) {
        require(msg.value == playGameFee);
        string memory computerChoice = determineComputerChoice();
        uint gameOutcome = determineGameOutcome(playerInput, computerChoice);
        string memory outputMessage = createOutputMessage(playerInput, computerChoice, gameOutcome);
        
        games.push(Game(playerInput, computerChoice, gameOutcome, outputMessage));
        uint id = games.length.sub(1);
        ownerGamesCount[msg.sender] = ownerGamesCount[msg.sender].add(1);
        gameToOwner[id] = msg.sender;
        emit NewGame(playerInput, computerChoice, gameOutcome, outputMessage);

        return outputMessage;
    }
}