async function main() {
    const contractAddress = "0x7A04c5660bBA30cfDf2F75Dacf42b69033b4b76a";
    const myContract = await hre.ethers.getContractAt("Deposit", contractAddress);
    
    // const mintToken = await myContract.addWhitelistedToken("0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7");
    const mintToken = await myContract.deposit("0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7", 20,{
        gas :500000
    });
    //0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7

    console.log(mintToken);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });