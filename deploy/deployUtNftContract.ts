import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployUtNftContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployer } = await hre.getNamedAccounts();
    const { deploy } = hre.deployments;

    await deploy("UtNft", {
        from: deployer,
        args: [],
        log: true,
    });
}

deployUtNftContract.tags = ["UtNft"];

export default deployUtNftContract;