// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "./libraries/Base64.sol";

//https://jsonkeeper.com/b/JVAX
//0x7b53DAED9adDE4775bf67f3a7d76dfBE07B7A1ab
//https://goerli.etherscan.io/tx/0x0c2086ce09504a7cd42f5ec7481706d3fe1d6523f2a44b02aef2f804d88e811f
contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Hi", "Hello", "Bye", "Yo", "Mix", "Grinder"];
    string[] secondWords = [
        "Apple",
        "Mango",
        "Banana",
        "Guava",
        "PineApple",
        "Avocado"
    ];
    string[] thirdWords = [
        "Matrix",
        "JaneDoe",
        "Queen",
        "Diana",
        "Charles",
        "HArry"
    ];

    uint256 totalNFT;
    uint256 remainingNFT;

    function getNftRatio() public view returns (string memory) {
        return
            string.concat(
                Strings.toString(remainingNFT),
                " out of ",
                Strings.toString(totalNFT),
                " NFT Minted So Far!!"
            );
    }

    constructor() ERC721("My NFT", "NFT") {
        console.log("This is my NFT contract. Whoa");
        totalNFT = 10;
        remainingNFT = 0;
    }

    function random(string memory input) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomFromList(
        string memory word,
        string[] memory wordList,
        uint256 token
    ) private pure returns (string memory) {
        uint256 randomNum = random(
            string(abi.encodePacked(word, Strings.toString(token)))
        );
        randomNum = randomNum % wordList.length;
        return wordList[randomNum];
    }

    function makeEpicNft() public {
        require(remainingNFT < totalNFT, "You have exhausted your NFT Limits");

        uint newItemId = tokenId.current();

        string memory pickFromFirst = pickRandomFromList(
            "FIRST",
            firstWords,
            newItemId
        );
        string memory pickFromSecond = pickRandomFromList(
            "SECOND",
            secondWords,
            newItemId
        );
        string memory pickFromThird = pickRandomFromList(
            "THIRD",
            thirdWords,
            newItemId
        );
        string memory combinedWord = string(
            abi.encodePacked(pickFromFirst, pickFromSecond, pickFromThird)
        );

        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg,
                pickFromFirst,
                pickFromSecond,
                pickFromThird,
                "</text></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        tokenId.increment();
        remainingNFT++;
        console.log("%s is newId amd %s is creator", newItemId, msg.sender);

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
