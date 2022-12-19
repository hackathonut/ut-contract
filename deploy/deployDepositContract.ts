import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployDepositContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployer } = await hre.getNamedAccounts();
    const { deploy } = hre.deployments;

    await deploy("Deposit", {
        from: deployer,
        args: [],
        log: true,
    });
}

deployDepositContract.tags = ["Deposit"];

export default deployDepositContract;