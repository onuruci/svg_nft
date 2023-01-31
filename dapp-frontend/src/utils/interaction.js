import { ethers } from "ethers";
import { decode as atob, encode as btoa } from "base-64";

const RPC_URL = "https://api.avax-test.network/ext/bc/C/rpc";
const SVG_ABI = require("./SVGABI.json");

const svgAddress = "0xB19db005C446E59dE8726E06735C5e454956Cc89";

export var svgContract;

export var signer;
export var provider;
export var walletAddress;

export const connectWallet = async (setAdress) => {
  if (window.ethereum) {
    await window.ethereum.enable();
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = await provider.getSigner();
    setAdress(await signer.getAddress());
    walletAddress = await signer.getAddress();

    svgContract = new ethers.Contract(svgAddress, SVG_ABI, signer);
  } else {
    return "You should install metamask";
  }
};

export const getCurrentWalletConnected = async (setAdress) => {
  if (window.ethereum) {
    try {
      const addressArray = await window.ethereum.request({
        method: "eth_accounts",
      });
      if (addressArray.length > 0) {
        provider = new ethers.providers.Web3Provider(window.ethereum);
        signer = await provider.getSigner();
        walletAddress = await signer.getAddress();
        setAdress(walletAddress);

        svgContract = new ethers.Contract(svgAddress, SVG_ABI, signer);
      } else {
        return {
          address: "",
          status: "Connect Metamask",
        };
      }
    } catch (err) {
      return {
        address: "",
        status: "Error",
      };
    }
  } else {
    return {
      address: "",
      status: "Install Metamask",
    };
  }
};

/// Mint

export const mintNFT = async (_color) => {
  if (svgContract) {
    await svgContract.mint(_color);
  }
};

/// User NFT's

export const getNFTs = async (setArr, setIds) => {
  let balance = await svgContract.balanceOf(walletAddress);
  console.log("Balance:  ", balance);
  let arr = [];
  let indarr = [];

  for (let i = 0; i < balance; i++) {
    let ind = parseInt(await svgContract.tokenOfOwnerByIndex(walletAddress, i));
    indarr.push(ind);
    let uri = await svgContract.tokenURI(ind);
    let json = atob(uri.substring(29));
    let result = await JSON.parse(json);
    arr.push(result.image);
  }

  setArr([...arr]);
  setIds([...indarr]);
};

export const getURI = async (_id) => {
  let uri = await svgContract.tokenURI(_id);
  return uri;
};

/// Breed

export const breed = async (_id1, _id2) => {
  await svgContract.breed(_id1, _id2);
};

export const listenToBreedEvent = async (setSuccess, setWaiting, setNFT) => {
  if (svgContract) {
    svgContract.on("CustomMint", async (owner, id) => {
      if (owner.toString() == walletAddress) {
        let uri = await svgContract.tokenURI(parseInt(id));
        let json = atob(uri.substring(29));
        let result = await JSON.parse(json);
        setNFT(result.image);
        setSuccess(true);
        setWaiting(false);
      }
    });
  }
};

/// List

export const getAllNFTs = async (setArr) => {
  let total = await svgContract.totalSupply();
  let arr = [];
  for (let i = 0; i < total; i++) {
    let uri = await svgContract.tokenURI(i);
    let json = atob(uri.substring(29));
    let result = await JSON.parse(json);
    arr.push(result.image);
  }

  setArr([...arr]);
};
