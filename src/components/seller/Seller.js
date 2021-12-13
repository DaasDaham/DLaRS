import { Box } from "@mui/material";
import React, { useState } from "react";
import styles from "../manager/styles/manager";
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import MainFunc from "../common/MainFunc";
import InnerForm from "../common/InnerForm";
import { useNavigate } from "react-router-dom";

const Seller = () => {
  const putForAuction = ["landId", "askingPrice", "minBidInterval"];
  const deleteFromAuction = ["landId"];
  const updateAuctionDetails = [
    "landId",
    "newAskingPrice",
    "newMinBidInterval",
  ];
  const acceptHighestBid = ["landId"];

  const [id, setId] = useState("");
  const [viewFunc, setViewFunc] = useState(false);
  const navigate = useNavigate();

  return (
    <>
      <Button
        onClick={() => {
          navigate("/");
        }}
      >
        Back
      </Button>
      <Box sx={styles.mainBox}>
        <Box sx={styles.mainHeading}>Seller</Box>
        <TextField
          sx={styles.input}
          id="outlined-basic"
          label="Enter your id"
          variant="outlined"
          value={id}
          onChange={(e) => setId(e.target.value)}
          required
        />
        <Button onClick={() => setViewFunc(true)}>View Functionality</Button>
        {viewFunc && <MainFunc id={id} />}
        {viewFunc && (
          <>
            <InnerForm
              inputArray={putForAuction}
              innerText="Put For Auction"
              id={id}
            />
            <InnerForm
              inputArray={deleteFromAuction}
              innerText="Delete From Auction"
              id={id}
            />
            <InnerForm
              inputArray={updateAuctionDetails}
              innerText="Update Auction Details"
              id={id}
            />
            <InnerForm
              inputArray={acceptHighestBid}
              innerText="Accept Highest Bid"
              id={id}
            />
          </>
        )}
      </Box>
    </>
  );
};
export default Seller;
