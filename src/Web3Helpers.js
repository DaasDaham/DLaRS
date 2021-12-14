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
async function putForAuctionHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .putUpForAuction(formDetails.landId, formDetails.askingPrice, formDetails.minBidInterval)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}
async function deleteFromAuctionHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .deleteFromAuction(formDetails.landId)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}
async function updateAuctionDetailsHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .updateAuctionDetails(formDetails.landId, formDetails.newAskingPrice, formDetails.newMinBidInterval)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}
async function acceptHighestBidHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .acceptHighestBid(formDetails.landId)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}
async function terminateAuctionHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .terminateAuction(formDetails.landId)
    .call({ from: accounts[0] })
    .then(function (result) {
      console.log(result);
    });
  console.log(fetchStatus);
}
async function placeBidHelper(dlarsObj, accounts, formDetails) {
  const fetchStatus = await dlarsObj.methods
    .placeBid(formDetails.landId, {from : accounts[0], value : formDetails.bidValue})
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
  putForAuctionHelper : putForAuctionHelper,
  deleteFromAuctionHelper : deleteFromAuctionHelper,
  terminateAuctionHelper : terminateAuctionHelper,
  acceptHighestBidHelper : acceptHighestBidHelper,
  placeBidHelper : placeBidHelper,
  updateAuctionDetailsHelper : updateAuctionDetailsHelper
};
