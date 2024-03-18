// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Challenge} from "src/Challenge.sol";

contract SolveScript is Script {
    Challenge challenge = Challenge(0xc07E8F4CAA3BebbD6e276Bec68cf312d250b1F7d);
    address alienspaceship = address(challenge.ALIENSPACESHIP());

    function run() public {
        vm.startBroadcast();

        alienspaceship.staticcall(abi.encodeWithSignature("abortMission()"));

        vm.stopBroadcast();
    }
}
