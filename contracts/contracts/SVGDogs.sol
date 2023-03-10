//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract SVGDogs is ERC721Enumerable {
    uint256 tokenCount = 0;

    mapping(uint256 => uint256[3]) svgValues;

    event CustomMint(address _owner, uint256 _id);
    event SampleMint(address _owner);

    enum RGBA {BLUE, RED, GREEN}

    constructor() ERC721("SvgNFT", "SVG") {}

    function mint(uint choice) public {
        require(choice >= 0 && choice < 3, "Color not in range");
        if(choice == uint(RGBA.BLUE)) {
            svgValues[tokenCount] = [255, 0, 0];
        } else if (choice == uint(RGBA.RED)) {
            svgValues[tokenCount] = [0, 255, 0];
        } else if(choice == uint(RGBA.GREEN)) {
            svgValues[tokenCount] = [0, 0, 255];
        }
        
        _safeMint(msg.sender, tokenCount++);
        emit SampleMint(msg.sender);
    }

    function mintCustom(uint256 r1, uint256 r2, uint256 r3) internal {
        svgValues[tokenCount] = [r1, r2, r3];
        _safeMint(msg.sender, tokenCount++);
        emit CustomMint(msg.sender, tokenCount-1);
    }

    function breed(uint256 id1, uint256 id2) public payable {
        require(ownerOf(id1) == msg.sender, "Not Owner!");
        require(ownerOf(id2) == msg.sender, "Not Owner!");
        require(id1 != id2, "Ids can't be the same");

        uint r1 = (svgValues[id1][0] + svgValues[id2][0]) / 2;
        uint r2 = (svgValues[id1][1] + svgValues[id2][1]) / 2;
        uint r3 = (svgValues[id1][2] + svgValues[id2][2]) / 2;

        mintCustom(r1, r2, r3);

    }

    function tokenURI(uint256 id) public view override returns(string memory) {
        return _buildTokenURI(id);
    }

    function getRBI(uint256 id) public view returns(string memory) {
        string memory rgbValues = string( abi.encodePacked('"',"rgba(" , Strings.toString(svgValues[id][0]), ',', Strings.toString(svgValues[id][1]), ",", Strings.toString(svgValues[id][2]),')','"'));
        return rgbValues;
    }

    function _buildTokenURI(uint256 id) internal view returns(string memory) {

        string memory rgbValues = string( abi.encodePacked('"',"rgba(" , Strings.toString(svgValues[id][0]), ',', Strings.toString(svgValues[id][1]), ",", Strings.toString(svgValues[id][2]),')','"'));

        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<svg fill="#000000" width="235px" height="235px" viewBox="-25.6 -25.6 307.20 307.20" id="Flat" xmlns="http://www.w3.org/2000/svg" stroke="#000000" stroke-width="0.00256" transform="rotate(0)">',
                        '<style type="text/css"><![CDATA[text { font-family: monospace; font-size: 21px;} .h1 {font-size: 40px; font-weight: 600;}]]></style>',
                        '<g id="SVGRepo_bgCarrier" stroke-width="0" transform="translate(17.92,17.92), scale(0.86)">',
                        '<rect x="-25.6" y="-25.6" width="307.20" height="307.20" rx="153.6" fill=', rgbValues, ' strokewidth="0"/>',
                        '</g>',
                        '<g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round" stroke="#CCCCCC" stroke-width="0.512"/>',
                        '<g id="SVGRepo_iconCarrier"> <path d="M100,140a8,8,0,1,1-8-8A8.00009,8.00009,0,0,1,100,140Zm64,8a8,8,0,1,0-8-8A8.00009,8.00009,0,0,0,164,148Zm67.0752-7.68408a12.19645,12.19645,0,0,1-5.043,1.10742,11.83693,11.83693,0,0,1-9.34766-4.62305L212,130.83813V184a36.04061,36.04061,0,0,1-36,36H80a36.04061,36.04061,0,0,1-36-36V130.83813l-4.68457,5.96216a11.83839,11.83839,0,0,1-9.34766,4.62305,12.19645,12.19645,0,0,1-5.043-1.10742A11.82706,11.82706,0,0,1,18.085,127.17529l16.418-87.5664A12.00119,12.00119,0,0,1,49.209,30.1792L104.49121,44h47.01758L206.792,30.1792a12.001,12.001,0,0,1,14.70508,9.4292l16.418,87.5664A11.82738,11.82738,0,0,1,231.0752,140.31592ZM97.04,50.3833,47.26855,37.93994a4.04357,4.04357,0,0,0-.98144-.12158,4.005,4.005,0,0,0-3.9209,3.26562l-16.418,87.56543a3.99987,3.99987,0,0,0,7.07617,3.2085ZM204,120.65625,150.05566,52H105.94434L52,120.65625V184a28.03146,28.03146,0,0,0,28,28h44V193.65674l-14.82812-14.82813a3.99991,3.99991,0,0,1,5.65624-5.65722L128,186.34326l13.17188-13.17187a3.99991,3.99991,0,0,1,5.65624,5.65722L132,193.65674V212h44a28.03146,28.03146,0,0,0,28-28Zm26.05176,7.99268-16.418-87.56543a3.99966,3.99966,0,0,0-4.90137-3.14356L158.96,50.3833l64.01563,81.47461a3.99993,3.99993,0,0,0,7.07617-3.209Z"/> </g>',
                        "</svg>"
                    )
                )
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"", "image":"',
                                image,
                                unicode'", "description": "."}'
                            )
                        )
                    )
                )
            );
    }
}