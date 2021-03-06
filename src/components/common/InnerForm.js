import React, { useState } from "react";
import { Box, Button } from "@mui/material";
import RootInput from "./RootInput";
import styles from "./styles/innerForm";
import Alert from "@mui/material/Alert";
import Web3 from "web3";
import { DLaRS_ABI, DLaRS_ADDRESS } from "../../DLaRS";
import {
  registerLandHelper,
  viewLandDetailsHelper,
  computeIdLandHelper,
  viewAuctionDetailsHelper,
  putForAuctionHelper,
  deleteFromAuctionHelper,
  updateAuctionDetailsHelper,
  acceptHighestBidHelper,
  terminateAuctionHelper,
  placeBidHelper,
} from "../../Web3Helpers";

let isInitialized = false;
let accounts;
let dlarsObj;

async function intialize() {
  console.log("In loadBlockainFirst");
  const web3 = new Web3(Web3.givenProvider || "http://127.0.0.1:7545");
  await window.ethereum.enable();
  accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);
  dlarsObj = new web3.eth.Contract(DLaRS_ABI, DLaRS_ADDRESS, {
    from: accounts[0],
  });
  isInitialized = true;
}

async function executionHandler(innerText, formDetails, setOutputString) {
  if (!isInitialized) {
    await intialize();
  }
  console.log(innerText);
  switch (innerText) {
    case "Register Land":
      //Done
      let landId = await registerLandHelper(dlarsObj, accounts, formDetails);
      console.log(landId + "console");
      setOutputString([<Box>Generated Land Id : {landId} </Box>]);
      break;
    case "View Land Details":
      //Done
      let landDetails = await viewLandDetailsHelper(
        dlarsObj,
        accounts,
        formDetails
      );
      let registeredStatus;
      if (landDetails[4] == 0) {
        registeredStatus = "Under Bidding";
      } else {
        registeredStatus = "Registered";
      }
      console.log("land Details");
      console.log(landDetails);
      setOutputString([
        <Box>Land Address : {landDetails[2]} </Box>,
        <Box>City : {landDetails[0]} </Box>,
        <Box>Country : {landDetails[1]} </Box>,
        <Box>PinCode : {landDetails[3]} </Box>,
        <Box>Status : {registeredStatus} </Box>,
      ]);
      break;
    case "Compute Id Land":
      await computeIdLandHelper(dlarsObj, accounts, formDetails);
      break;
    case "View Auction Details":
      //Done
      let aucDetails = await viewAuctionDetailsHelper(
        dlarsObj,
        accounts,
        formDetails
      );
      console.log("AUC Details");
      console.log(aucDetails);
      setOutputString([
        <Box>Highest Bid : {aucDetails[0]} </Box>,
        <Box>Initial Asking Price (Wei) : {aucDetails[1]} </Box>,
        <Box>Last Bid's Timestamp : {aucDetails[2]} </Box>,
      ]);

      break;
    case "Put For Auction":
      //Done
      await putForAuctionHelper(dlarsObj, accounts, formDetails);
      break;
    case "Delete From Auction":
      // Done
      await deleteFromAuctionHelper(dlarsObj, accounts, formDetails);
      break;
    case "Update Auction Details":
      await updateAuctionDetailsHelper(dlarsObj, accounts, formDetails);
      break;
    case "Accept Highest Bid":
      //Done
      await acceptHighestBidHelper(dlarsObj, accounts, formDetails);
      break;
    case "Terminate Auction":
      await terminateAuctionHelper(dlarsObj, accounts, formDetails);
      break;
    case "Place Bid":
      //Done
      await placeBidHelper(dlarsObj, accounts, formDetails);
      break;
    default:
      console.log("NONE " + innerText);
      return "None";
  }
}

const InnerForm = ({ inputArray, innerText, id }) => {
  console.log("this is passed id ", id);
  let initObj = { id };
  const [showForm, setShowForm] = useState(false);

  inputArray.map((input) => {
    initObj = { ...initObj, [input]: "" };
  });

  const [formDetails, setFormDetails] = useState(initObj);
  const [showOutput, setShowOutput] = useState(false);
  const [isError, setIsError] = useState(false);
  const [outputString, setOuptutString] = useState("");

  console.log("this is form details", formDetails);

  // submitHandler
  const submitHandler = (e) => {
    console.log("submitHandler");
    setIsError(false);
    e.preventDefault();
    setShowOutput(true);
    intialize();
    executionHandler(innerText, formDetails, setOuptutString);
  };

  // clickHandler
  const clickHandler = () => {
    setShowForm((prev) => !prev);
  };

  return (
    <Box
      sx={{
        width: "100%",
      }}
    >
      <Button
        onClick={clickHandler}
        color="error"
        style={styles.btn}
        variant="contained"
      >
        {innerText}
      </Button>
      {showForm && (
        <Box sx={styles.formBox}>
          <form style={styles.form} onSubmit={submitHandler}>
            {inputArray.map((input, index) => {
              return (
                <RootInput
                  key={index}
                  value={formDetails[input]}
                  onChange={(e) =>
                    setFormDetails((prevState) => {
                      return {
                        ...prevState,
                        [input]: e.target.value,
                      };
                    })
                  }
                  placeholder={input}
                />
              );
            })}
            <Button
              style={styles.submitBtn}
              color="secondary"
              type="submit"
              variant="contained"
            >
              Submit
            </Button>
          </form>
        </Box>
      )}
      {showOutput && (
        <Alert
          onClose={() => setShowOutput(false)}
          sx={styles.alert}
          severity={!isError ? "success" : "error"}
        >
          {isError ? (
            <Box>Error Occured</Box>
          ) : (
            <Box>Transaction Successful! {outputString}</Box>
          )}
        </Alert>
      )}
    </Box>
  );
};

export default InnerForm;
