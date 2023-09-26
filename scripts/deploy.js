
const { hre } = require("hardhat");

const tokens = (nToken) => {
  return ethers.utils.parseunits(nToken.toString(), "ether");
}

async function main() {
  const initialsupply = tokens(5000000);
  const Token = await hre.ethers.getContractFactory("Token");
  const token = await Token.deploy(initialsupply); //constructor 
  await token.deployed();

  //Token has the entire  of the contract & from there we are simply accessing the address
  console.log(`Token: ${token.address}`);

  //TokenSale Contract
  const tokenprice = tokens(5000000);
  const TokenSale = await hre.ethers.getContractFactory("Token");
  const tokensale = await TokenSale.deploy(tokenprice, token.address); // constructor 
  await tokensale.deployed();

  //Token has the entire  of the contract & from there we are simply accessing the address
  console.log(`TokenSale: ${tokensale.address}`);

};

main().catch((error) => {
  console.error(error)
  process.exitCode = 1;
});
