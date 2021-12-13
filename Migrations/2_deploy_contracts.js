var DLaRS = artifacts.require("../contracts/DLaRS.sol");

module.exports = function(deployer) {
  deployer.deploy(DLaRS);
};