// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Challenge {
    AlienSpaceship public immutable ALIENSPACESHIP;

    constructor(address alienspaceship) {
        ALIENSPACESHIP = AlienSpaceship(alienspaceship);
    }

    function isSolved() external view returns (bool) {
        return ALIENSPACESHIP.missionAborted();
    }
}

interface AlienSpaceship {
    function missionAborted() external view returns (bool); //e7511d8d
}
// address alienspaceship = address(challenge.ALIENSPACESHIP());
// (bool success, bytes memory results) = alienspaceship.staticcall(abi.encodeWithSignature("missionAborted()"));
// (success, results) = alienspaceship.staticcall(abi.encodeWithSignature("owner()"));
// abortMission 7235a6d5
