// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./ownable.sol";

contract RockPaperScissors is Ownable {

    event NewGame(string playerInput, string computerChoice, uint gameOutcome, string outputMessage);

    struct Game {
        string playerInput;
        string computerChoice;
        uint  gameOutcome;
        string outputMessage;
    }

    Game[] public games;

    mapping (uint => address) public gameToOwner;
    mapping (address => uint) public ownerGamesCount;

    function playRockPaperScissors(string memory playerInput) public returns (string memory) {
        string memory computerChoice = determineComputerChoice();
        uint gameOutcome = determineGameOutcome(playerInput, computerChoice);
        string memory outputMessage = createOutputMessage(playerInput, computerChoice, gameOutcome);
        
        games.push(Game(playerInput, computerChoice, gameOutcome, outputMessage));
        uint id = games.length - 1;
        ownerGamesCount[msg.sender]++;
        gameToOwner[id] = msg.sender;
        emit NewGame(playerInput, computerChoice, gameOutcome, outputMessage);

        return outputMessage;
    }


    function randMod() internal view returns(uint) {
        //Generates a random number between 0 and 100.
        uint randNonce = 0;
        uint modulus = 100;
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    }


    function determineComputerChoice() internal view returns (string memory) {
        //Determine whether the computer chooses rock, paper or scissors.
        uint border1 = 33;
        uint border2 = 66;
        uint randomNumber = randMod();
        string memory computerChoice;

        if (randomNumber < border1) {
            computerChoice = "rock";
        } else if (randomNumber > border1 && randomNumber < border2) {
            computerChoice = "paper";
        } else if (randomNumber > border2) {
            computerChoice = "scissors";
        }

        return computerChoice;
    }

    function determineGameOutcome(string memory playerInput, string memory computerChoice) internal pure returns (uint) {
        //Determine the outcome of the game.
        string memory rock = "rock";
        string memory paper = "paper";
        string memory scissors = "scissors";
        uint gameOutcome;
        
        if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(rock)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(rock))) {
            gameOutcome = 0;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(rock)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(paper))) {
            gameOutcome = 2;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(rock)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(scissors))) {
            gameOutcome = 1;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(paper)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(rock))) {
            gameOutcome = 2;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(paper)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(paper))) {
            gameOutcome = 0;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(paper)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(scissors))) {
            gameOutcome = 2;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(scissors)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(rock))) {
            gameOutcome = 2;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(scissors)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(paper))) {
            gameOutcome = 1;
        } else if (keccak256(abi.encodePacked(playerInput)) == keccak256(abi.encodePacked(scissors)) && keccak256(abi.encodePacked(computerChoice)) == keccak256(abi.encodePacked(scissors))) {
            gameOutcome = 0;
        }

        return gameOutcome;
    }

    function createOutputMessage(string memory playerInput, string memory computerChoice, uint gameOutcome) internal pure returns (string memory) {
        string memory outputMessage;
        string memory endOfMessage;

        if (gameOutcome == 0) {
            endOfMessage = ". The game ended in a draw.";
        } else if (gameOutcome == 1) {
            endOfMessage = ". You won the game.";
        } else if (gameOutcome == 2) {
            endOfMessage = ". You lost the game.";
        }

        outputMessage = string(abi.encodePacked("You picked ", playerInput, " and the computer picked ", computerChoice, endOfMessage));
        
        return outputMessage;
    }
}