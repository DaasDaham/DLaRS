async function registerLandHelper(dlarsObj, accounts, formDetails) {
  dlarsObj.methods
    .getManagerAddress()
    .call()
    .then(function (result) {
      console.log("Manager:" + result);
    });
  console.log(formDetails);
  const landRegistryStatus = await dlarsObj.methods
    .registerLand(
      formDetails.landAddress,
      formDetails.city,
      formDetails.country,
      formDetails.pinCode,
      formDetails.payableCurrentOwner
    )
    .send({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log("After Blockchain");
  console.log(landRegistryStatus);
}

async function viewLandDetailsHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .viewLandDetails(formDetails.landId)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}

async function computeIdLandHelper(dlarsObj, accounts, formDetails) {
  console.log("computeIdLandHelper");
  console.log(accounts);
  console.log(formDetails);
  const lid = await dlarsObj.methods
    .computeIdLand(
      formDetails.landAddress,
      formDetails.city,
      formDetails.country,
      formDetails.pinCode
    )
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
}

async function viewAuctionDetailsHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .viewAuctionDetails(formDetails.landId)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}

module.exports = {
  registerLandHelper: registerLandHelper,
  viewLandDetailsHelper: viewLandDetailsHelper,
  computeIdLandHelper: computeIdLandHelper,
  viewAuctionDetailsHelper: viewAuctionDetailsHelper,
};
