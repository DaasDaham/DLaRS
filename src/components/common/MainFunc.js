import { Box, Button } from "@mui/material";
import React from "react";
import InnerForm from "./InnerForm";

const styles = {
  btnBox: {
    mt: "1rem",
    width: "100%",
  },
  // using styles
  btn: {
    // backgroundColor: "blue !important",
    marginRight: "1rem",
  },
};

const MainFunc = ({ id }) => {
  const viewLandDetails = ["landId"];
  const computeIdLand = ["landAddress", "city", "country", "pincode"];
  const viewAuctionDetails = ["landId"];

  return (
    <Box sx={styles.btnBox}>
      <InnerForm
        inputArray={viewLandDetails}
        innerText="View Land Details"
        id={id}
      />
      <InnerForm
        inputArray={computeIdLand}
        innerText="Compute Id Land"
        id={id}
      />
      <InnerForm
        inputArray={viewAuctionDetails}
        innerText=" View Auction Details"
        id={id}
      />
    </Box>
  );
};

export default MainFunc;
